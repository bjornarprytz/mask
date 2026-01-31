class_name ControlsInterface
extends Node2D


func get_aim(base:Vector2=Vector2.ZERO) -> Vector2:
	if Events.control_scheme == Events.ControlScheme.GAMEPAD:
		return Input.get_vector("secondary_left", "secondary_right", "secondary_up", "secondary_down", .1)
	else:
		var mouse_pos = get_global_mouse_position()
		return mouse_pos - base
