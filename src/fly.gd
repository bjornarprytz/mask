class_name Fly
extends PathFollow2D

var path: FlyPath
@export var move_speed: float = 20.0

func die():
	queue_free()
	path.queue_free()

func _ready() -> void:
	path = Create.fly_path()
	get_tree().root.call_deferred("add_child", path)
	path.global_position = global_position
	path.rotation_degrees = randf_range(0, 360)
	self.call_deferred("reparent", path)
	
	# Start from the beginning of the path
	progress = 0.0

func _process(delta: float) -> void:
	# Move along the path
	progress += delta * move_speed
	
	# Update the path direction based on current movement
	if path:
		path.set_direction_from_fly(progress)

	
	# No need to loop - the path extends infinitely
