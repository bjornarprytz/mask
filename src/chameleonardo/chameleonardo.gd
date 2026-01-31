class_name Chameleonardo
extends Node2D

@export var move_speed: float = 100.0
@export var rotation_speed: float = 2.0

@onready var body: AnimatedSprite2D = %Body
@onready var head: Head = %Head
@onready var tongue_anchor: Node2D = %TongueAnchor

var shoot_action: Shoot = null
var is_shooting: bool = false

var color_tween: Tween

func _process(delta: float) -> void:
	if (not is_shooting):
		_move_body(delta)
	_move_head(delta)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		if (is_shooting): # Acts as a cooldown
			return
		is_shooting = true
		shoot_action = Create.shoot()
		tongue_anchor.add_child(shoot_action)
	if event.is_action_released("shoot"):
		if (is_shooting == false):
			return
		shoot_action.fire()
		await shoot_action.finished
		is_shooting = false
	if event.is_action_pressed("chamele"):
		_chamele()

func _chamele():
	# TODO: Check the color of the (sprite) underneath
	var color = Palette.colors.pick_random()

	color_tween = create_tween()
	color_tween.tween_property(self, "modulate", color, 1.5)


func _move_body(delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down", .1)
	
	if input_vector != Vector2.ZERO:
		# Rotate towards the input direction
		var target_angle = input_vector.angle()
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
		
		# Move forward based on current rotation
		var forward = Vector2.RIGHT.rotated(rotation)
		position += forward * input_vector.length() * move_speed * delta
	

func _move_head(_delta: float) -> void:
	var aim_vector = Controls.get_aim(head.global_position)

	if aim_vector != Vector2.ZERO:
		head.global_rotation = aim_vector.angle()
	else:
		head.rotation = lerp_angle(head.rotation, 0.0, 0.1)
