extends Node2D

@onready var keyboard_button: Button = %KeyboardButton
@onready var gamepad_button: Button = %GamepadButton
@onready var start_button: Button = %StartButton

func _ready() -> void:
	if Events.control_scheme == EventBus.ControlScheme.KEYBOARD:
		keyboard_button.button_pressed = true

func _on_keyboard_button_toggled(toggled_on: bool) -> void:
	if (toggled_on):
		Events.control_scheme = EventBus.ControlScheme.KEYBOARD
		print("Change to keyboard")
	else:
		print("1off")

func _on_gamepad_button_toggled(toggled_on: bool) -> void:
	if (toggled_on):
		Events.control_scheme = EventBus.ControlScheme.GAMEPAD
		print("Change to game pad")
	else:
		print("2off")


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
