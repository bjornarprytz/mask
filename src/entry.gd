extends Node2D

func _on_keyboard_button_toggled(toggled_on: bool) -> void:
	if (toggled_on):
		Events.control_scheme = EventBus.ControlScheme.KEYBOARD

func _on_gamepad_button_toggled(toggled_on: bool) -> void:
	if (toggled_on):
		Events.control_scheme = EventBus.ControlScheme.GAMEPAD


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
