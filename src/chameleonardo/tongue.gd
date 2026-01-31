class_name Tongue
extends Node2D

@onready var stretch: ColorRect = %Stretch
@onready var ball: Sprite2D = %Ball
@onready var hitbox: Area2D = %Hitbox

@export var duration: float = .5
var target_vector: Vector2
var tween: Tween

signal hit(fly: Fly)
signal retracted()
signal done()

var is_done = false

func _process(_delta: float) -> void:
	# Rotate the tongue towards the target vector
	if target_vector != Vector2.ZERO:
		global_rotation = target_vector.angle()

func shoot(global_target: Vector2):
	hitbox.monitoring = true
	target_vector = global_target - global_position
	var distance = target_vector.length()
	# tween the tounge toward target
	tween = create_tween().set_parallel()
	tween.tween_property(stretch, "size:x", distance, duration)
	tween.tween_property(ball, "global_position", global_target, duration)
	tween.chain()
	tween.tween_callback(_retract)

func _on_hitbox_area_entered(area: Area2D) -> void:
	if (area.owner is Fly):
		hit.emit(area.owner)
		_retract()

func _retract():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(stretch, "size:x", 0, duration)
	tween.set_parallel()
	tween.tween_property(ball, "position", Vector2.ZERO, duration)
	tween.chain()
	tween.tween_callback(_on_retracted)

func _on_retracted():
	retracted.emit()
	done.emit()
	is_done = true
