class_name Chameleonardo
extends Node2D

@export var eye_frame_count: int = 6

@export var move_speed: float = 100.0
@export var rotation_speed: float = 2.0

@onready var body: Sprite2D = %Body
@onready var head: Sprite2D = %Head

@onready var left_eye: AnimatedSprite2D = %LeftEye
@onready var right_eye: AnimatedSprite2D = %RightEye

@onready var left_eye_sensor: Area2D = %LeftEyeSensor
@onready var right_eye_sensor: Area2D = %RightEyeSensor

var left_focus: Node2D = null
var right_focus: Node2D = null

func _process(delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down", .1)
	
	if input_vector != Vector2.ZERO:
		# Rotate towards the input direction
		var target_angle = input_vector.angle()
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
		
		# Move forward based on current rotation
		var forward = Vector2.RIGHT.rotated(rotation)
		position += forward * input_vector.length() * move_speed * delta

	var secondary_vector = Input.get_vector("secondary_left", "secondary_right", "secondary_up", "secondary_down", .1)

	if secondary_vector != Vector2.ZERO:
		head.global_rotation = secondary_vector.angle()
	else:
		head.rotation = lerp_angle(head.rotation, 0.0, 0.1)
		
	focus_on()


func focus_on() -> void:
	focus_eye(left_eye, left_focus)
	focus_eye(right_eye, right_focus)

func focus_eye(eye: AnimatedSprite2D, node: Node) -> void:
	if (node == null):
		return
	
	var to_position = (node.global_position - eye.global_position)
	var distance = to_position.length() / 50.0

	var frame_n = clamp(floor((distance / PI) * eye_frame_count), 0, eye_frame_count - 1)

	eye.frame = frame_n
	eye.global_rotation = to_position.angle()

func _on_right_eye_sensor_area_entered(area: Area2D) -> void:
	if (right_focus != null):
		return
	if (area.owner is Fly):
		right_focus = area.owner


func _on_left_eye_sensor_area_entered(area: Area2D) -> void:
	if (left_focus != null):
		return
	if (area.owner is Fly):
		left_focus = area.owner.owner


func _on_right_eye_sensor_area_exited(_area: Area2D) -> void:
	var any = right_eye_sensor.get_overlapping_areas()
	any.shuffle()
	for a in any:
		if (a.owner is Fly):
			right_focus = a.owner
			return
	right_focus = null


func _on_left_eye_sensor_area_exited(_area: Area2D) -> void:
	var any = left_eye_sensor.get_overlapping_areas()
	any.shuffle()
	for a in any:
		if (a.owner is Fly):
			left_focus = a.owner
			return
	left_focus = null
