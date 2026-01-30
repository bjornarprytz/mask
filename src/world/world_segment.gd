class_name WorldSegment
extends Node2D

const SEGMENT_SIZE: Vector2 = Vector2(1280, 720)

func hibernate() -> void:
	set_process(false)

func wake_up() -> void:
	set_process(true)

func _ready() -> void:
	for i in range(randi_range(4, 10)):
		await delay(0.03)
		spawn_feature(_random_position_within())

func _random_position_within() -> Vector2:
	return Vector2(
		randf_range(0, SEGMENT_SIZE.x),
		randf_range(0, SEGMENT_SIZE.y)
	)

func delay(t: float):
	return get_tree().create_timer(t).timeout

func spawn_feature(local_pos: Vector2) -> void:
	# TODO: Spawn a feature (monstera leaf or rock) at the given local position
	pass
