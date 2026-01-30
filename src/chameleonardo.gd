class_name Chameleonardo
extends Node2D

@export var move_speed: float = 300.0

@onready var body: Sprite2D = %Body
@onready var head: Sprite2D = %Head

func _process(delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down", .1)
	
	if input_vector != Vector2.ZERO:
		position += input_vector * move_speed * delta
		rotation = input_vector.angle()

	var secondary_vector = Input.get_vector("secondary_left", "secondary_right", "secondary_up", "secondary_down", .1)

	if secondary_vector != Vector2.ZERO:
		head.global_rotation = secondary_vector.angle()
	else:
		head.rotation = lerp_angle(head.rotation, 0.0, 0.1)
