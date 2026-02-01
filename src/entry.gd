extends Node2D

@onready var keyboard_button: Button = %KeyboardButton
@onready var gamepad_button: Button = %GamepadButton
@onready var start_button: Button = %StartButton
@onready var timer: Timer = $Timer

func _ready() -> void:
	if Events.control_scheme == EventBus.ControlScheme.KEYBOARD:
		keyboard_button.button_pressed = true
	
	Audio.start_theme(preload("res://assets/audio/OneMoreFly - full.mp3"))

func _on_keyboard_button_toggled(toggled_on: bool) -> void:
	if (toggled_on):
		Events.control_scheme = EventBus.ControlScheme.KEYBOARD
		keyboard_button.text = "[Keyboard]"
	else:
		keyboard_button.text = "Keyboard"

func _on_gamepad_button_toggled(toggled_on: bool) -> void:
	if (toggled_on):
		Events.control_scheme = EventBus.ControlScheme.GAMEPAD
		gamepad_button.text = "[Gamepad]"
	else:
		gamepad_button.text = "Gamepad"


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_timer_timeout() -> void:
	# Get a random position on the screen
	var screen_size = get_viewport_rect().size
	var random_position = Vector2(randi() % int(screen_size.x), randi() % int(screen_size.y))
	# Create a feature there
	var feature = Create.feature(Palette.colors.pick_random())
	feature.position = random_position
	feature.modulate.a = 0.0
	add_child(feature)

	var tween = create_tween()
	tween.tween_property(feature, "modulate:a", 1.0, 1.0)


func _on_start_button_mouse_entered() -> void:
	#await NodeEffects.sheen(start_button)
	pass
