extends Node2D

func _on_keyboard_button_pressed() -> void:
	Events.control_scheme = EventBus.ControlScheme.KEYBOARD
	get_tree().change_scene_to_file("res://main.tscn")

func _on_gamepad_button_pressed() -> void:
	Events.control_scheme = EventBus.ControlScheme.GAMEPAD
	get_tree().change_scene_to_file("res://main.tscn")
