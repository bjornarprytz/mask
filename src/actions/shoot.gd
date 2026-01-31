class_name Shoot
extends Node2D

@onready var tongue: Tongue = %Tongue

@export var shoot_range: float = 200.0

signal finished()

var time_tween: Tween


func _ready() -> void:
	_move_time_to_target(0.5, 0.1)

func _move_time_to_target(target: float, duration: float):
	if time_tween:
		time_tween.kill()
	time_tween = create_tween().set_ignore_time_scale(true)
	time_tween.tween_method(_control_time, Engine.time_scale, target, duration)
	await time_tween.finished

func _control_time(f: float):
	Engine.time_scale = f

func fire():
	var aim = Controls.get_aim(global_position)
	tongue.shoot(global_position + aim.normalized() * shoot_range)
	tongue.hit.connect(_on_hit, CONNECT_ONE_SHOT)

	_move_time_to_target(1.0, 0.2)
	await tongue.done

	_clean_up()

func _on_hit(fly: Fly) -> void:
	fly.die()


func _clean_up() -> void:
	if time_tween != null and time_tween.is_running():
		await time_tween.finished

	finished.emit()
	queue_free()
