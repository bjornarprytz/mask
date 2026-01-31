class_name Chameleonardo
extends Node2D

@export var body_frame_count: int = 10

@export var move_speed: float = 30.0
@export var rotation_speed: float = 2.0

@onready var body: AnimatedSprite2D = %Body
@onready var head: Head = %Head
@onready var tongue_anchor: Node2D = %TongueAnchor
@onready var chamele_sense: Area2D = %ChameleSense

var shoot_action: Shoot = null
var is_shooting: bool = false

var movement_distance = 10000.0 # Otherwise backwards movement doesn't animate from the get go

var color_tween: Tween

var stealth_range := 0.0

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
	var feature = _get_feature()
	var color: Color
	if feature == null:
		color = Palette.colors.pick_random()
		return
	else:
		color = feature.color

	color_tween = create_tween()
	color_tween.tween_property(self , "modulate", color, 1.5)

func _get_feature() -> Feature:
	var areas = chamele_sense.get_overlapping_areas()
	
	areas.reverse()
	for area in areas:
		if area.owner is Feature:
			print("Found feature %s" % area.owner)
			return area.owner
		
	return null


func _move_body(delta: float) -> void:
	var distance = 0.0
	var rot = 0.0
	
	if Events.control_scheme == Events.ControlScheme.GAMEPAD:
		var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down", .1)
		
		if input_vector != Vector2.ZERO:
			# Rotate towards the input direction
			var target_angle = input_vector.angle()
			rot = lerp_angle(rotation, target_angle, rotation_speed * delta)
			distance = input_vector.length() * move_speed * delta
	else:
		# WASD. W moves along the forward direction, S backward, A and D rotate.
		rot = rotation
		if Input.is_action_pressed("ui_left"):
			rot -= rotation_speed * delta
		if Input.is_action_pressed("ui_right"):
			rot += rotation_speed * delta

		if Input.is_action_pressed("ui_up"):
			distance += move_speed * delta
		if Input.is_action_pressed("ui_down"):
			distance -= move_speed * delta

	var forward = Vector2.RIGHT.rotated(rotation)
	position += forward * distance
	rotation = rot

	movement_distance += distance

	body.frame = int(movement_distance / 8) % body_frame_count
	

func _move_head(_delta: float) -> void:
	var aim_vector = Controls.get_aim(head.global_position)

	if aim_vector != Vector2.ZERO:
		head.global_rotation = aim_vector.angle()
	else:
		head.rotation = lerp_angle(head.rotation, 0.0, 0.1)
