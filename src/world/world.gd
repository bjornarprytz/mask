class_name World
extends Node2D

@export var chameleonardo: Chameleonardo

var segments: Dictionary[Vector2i, WorldSegment] = {}

var current_segment_coord: Vector2i

func _ready() -> void:
	current_segment_coord = get_segment_coords_at_position(chameleonardo.global_position)

	for x in range(current_segment_coord.x - 1, current_segment_coord.x + 2):
		for y in range(current_segment_coord.y - 1, current_segment_coord.y + 2):
			create_or_wake_up_segment_at_coords(Vector2i(x, y))


func _process(_delta: float) -> void:
	var new_segment_coord = get_segment_coords_at_position(chameleonardo.global_position)
	if new_segment_coord != current_segment_coord:
		# Hibernate segments that are no longer in the 3x3 grid
		for coord in segments.keys():
			if coord.x < new_segment_coord.x - 1 or coord.x > new_segment_coord.x + 1 or coord.y < new_segment_coord.y - 1 or coord.y > new_segment_coord.y + 1:
				hibernate_at_coords(coord)
		
		# Create or wake up segments in the new 3x3 grid
		for x in range(new_segment_coord.x - 1, new_segment_coord.x + 2):
			for y in range(new_segment_coord.y - 1, new_segment_coord.y + 2):
				create_or_wake_up_segment_at_coords(Vector2i(x, y))
		
		current_segment_coord = new_segment_coord

func get_segment_coords_at_position(pos: Vector2i) -> Vector2i:
	return Vector2i(
		floor(pos.x / WorldSegment.SEGMENT_SIZE.x),
		floor(pos.y / WorldSegment.SEGMENT_SIZE.y)
	)

func get_segment_at_position(pos: Vector2i) -> WorldSegment:
	var segment_coords = get_segment_coords_at_position(pos)
	if segments.has(segment_coords):
		return segments[segment_coords]
	return null

func hibernate_at_coords(coords: Vector2i) -> void:
	if segments.has(coords):
		segments[coords].hibernate()

func create_or_wake_up_segment_at_coords(coords: Vector2i) -> void:
	if segments.has(coords):
		segments[coords].wake_up()
		return
	
	var segment = preload("res://world/world_segment.tscn").instantiate() as WorldSegment
	segment.position = (Vector2(coords) * WorldSegment.SEGMENT_SIZE)
	add_child(segment)
	segments[coords] = segment
