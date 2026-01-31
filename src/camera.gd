extends Camera2D

@export var target: Node2D

@export var lerp_speed: float = 5.0

# Ignore timescale

func _process(delta: float) -> void:
	if (Engine.time_scale != 0.0):
		delta = delta / abs(Engine.time_scale) # Adjust delta to ignore time scale
	global_position = lerp(global_position, target.global_position, delta * lerp_speed)
