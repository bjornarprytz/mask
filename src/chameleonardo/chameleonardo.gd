class_name Chameleonardo
extends Node2D

@export var move_speed: float = 100.0
@export var rotation_speed: float = 2.0

@onready var body: Sprite2D = %Body
@onready var head: Head = %Head
@onready var tongue_anchor: Node2D = %TongueAnchor

var tongue: Tongue = null

func _ready() -> void:
	Events.chameleonardo = self

func _process(delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down", .1)
	
	if input_vector != Vector2.ZERO:
		# Rotate towards the input direction
		var target_angle = input_vector.angle()
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
		
		# Move forward based on current rotation
		var forward = Vector2.RIGHT.rotated(rotation)
		position += forward * input_vector.length() * move_speed * delta

	var secondary_vector = get_secondary_vector()

	if secondary_vector != Vector2.ZERO:
		head.global_rotation = secondary_vector.angle()
	else:
		head.rotation = lerp_angle(head.rotation, 0.0, 0.1)
		
	
func get_secondary_vector() -> Vector2:
	if Events.control_scheme == Events.ControlScheme.GAMEPAD:
		return Input.get_vector("secondary_left", "secondary_right", "secondary_up", "secondary_down", .1)
	else:
		var mouse_pos = get_global_mouse_position()
		return mouse_pos - head.global_position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		if (tongue != null): # Acts as a cooldown
			return
		tongue = Create.tongue()
		tongue_anchor.add_child(tongue)
		tongue.position = Vector2.ZERO
		tongue.rotation = 0.0
		var secondary_vector = get_secondary_vector()
		tongue.shoot(tongue_anchor.global_position + secondary_vector.normalized() * 200.0)
		tongue.hit.connect(_on_hit, CONNECT_ONE_SHOT)

func _on_hit(fly: Fly) -> void:
	fly.die()
