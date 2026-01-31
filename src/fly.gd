class_name Fly
extends PathFollow2D

var chars := "abcdefghijklnopqrstuxyzæøå123456789"
var path: FlyPath
@export var move_speed: float = 250.0
@export var flap_speed: float = 20.0

@onready var r_wing: Node2D = %RWing
@onready var l_wing: Node2D = %LWing
@onready var r_form: RichTextLabel = %RForm
@onready var l_form: RichTextLabel = %LForm

@onready var flap_offset = randf()

func set_form(l: String):
	r_form.bbcode_text = l
	l_form.bbcode_text = l

func die(with_effect: bool = true) -> void:
	if with_effect:
		# TODO: Add death effect
		pass
	queue_free()
	path.queue_free()

func _ready() -> void:
	path = Create.fly_path()
	get_tree().root.call_deferred("add_child", path)
	path.global_position = global_position
	path.rotation_degrees = randf_range(0, 360)
	self.call_deferred("reparent", path)
	
	# Start from the beginning of the path
	progress = 0.0
	
	set_form(chars[randi_range(0, chars.length() - 1)])

func _check_distance_to_chameleonardo() -> void:
	if (!Events.game):
		return
	var chameleonardo = Events.game.chameleonardo
	if chameleonardo == null:
		return
	
	var distance = global_position.distance_to(chameleonardo.global_position)
	if distance > 800.0:
		die(false)

func _process(delta: float) -> void:
	# Move along the path
	progress += delta * move_speed
	
	# Update the path direction based on current movement
	if path:
		path.set_direction_from_fly(progress)
	
	var elapsed = Time.get_ticks_msec() / 1000.0
	var flap = pingpong((elapsed * flap_speed) + flap_offset, 1.0)
	
	l_wing.scale.y = flap
	r_wing.scale.y = flap

	_check_distance_to_chameleonardo()
