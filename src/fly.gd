class_name Fly
extends PathFollow2D


var path: FlyPath
@export var move_speed: float = 250.0
@export var flap_speed: float = 20.0

@onready var r_wing: Node2D = %RWing
@onready var l_wing: Node2D = %LWing
@onready var r_form: RichTextLabel = %RForm
@onready var l_form: RichTextLabel = %LForm
@onready var startle: Node2D = %Startle

@onready var flap_offset = randf()

var letter: String = ""

func set_form(l: String):
	r_form.bbcode_text = l
	l_form.bbcode_text = l
	letter = l

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
	
	
	set_form(Events.get_char())
	

func _check_distance_to_chameleonardo() -> void:
	if (!Events.game):
		return
	var chameleonardo = Events.game.chameleonardo
	if chameleonardo == null:
		return
	
	var distance = global_position.distance_to(chameleonardo.global_position)
	if distance > 1200.0:
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

func flee() -> void:
	if !path or !Events.game:
		return
	
	var chameleonardo = Events.game.chameleonardo
	if chameleonardo == null:
		return
	
	# Flicker the startle effect
	startle.visible = true
	var tween = create_tween()
	tween.tween_interval(0.2)
	tween.tween_callback(startle.hide)
	tween.tween_interval(0.2)
	tween.tween_callback(startle.show)
	tween.tween_interval(0.2)
	tween.tween_callback(startle.hide)
	



	# Calculate direction away from the chameleon
	var direction_away = (global_position - chameleonardo.global_position).normalized()
	
	# Redirect the path in that direction
	path.redirect_path(direction_away)
	
	# Increase speed when fleeing
	move_speed = 400.0
