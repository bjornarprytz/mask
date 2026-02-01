class_name Shoot
extends Node2D

@onready var tongue: Tongue = %Tongue

@export var shoot_range: float = 200.0
@export var max_zoom: Vector2 = Vector2.ONE * 2.0

@onready var camera: Camera2D = Events.game.camera
@onready var orig_zoom: Vector2 = camera.zoom

signal finished()

var time_tween: Tween
var camera_tween: Tween
var is_firing: bool = false


func _ready() -> void:
	camera.target = tongue.ball
	_move_time_to_target(0.5, 0.5)
	_move_camera_to_zoom(max_zoom, 1.0)
	

func _move_camera_to_zoom(target: Vector2, duration: float):
	if camera_tween:
		camera_tween.kill()
	camera_tween = create_tween().set_ignore_time_scale(true)
	camera_tween.set_ease(Tween.EASE_OUT)
	camera_tween.tween_property(Events.game.camera, "zoom", target, duration)
	await camera_tween.finished

func _move_time_to_target(target: float, duration: float):
	if time_tween:
		time_tween.kill()
	time_tween = create_tween().set_ignore_time_scale(true)
	time_tween.set_ease(Tween.EASE_OUT)
	time_tween.tween_method(_control_time, Engine.time_scale, target, duration)
	await time_tween.finished

func _control_time(f: float):
	Engine.time_scale = f
	Audio.music.pitch_scale = f
	

func fire():
	is_firing = true
	var aim = Controls.get_aim(global_position)
	tongue.shoot(global_position + aim.normalized() * shoot_range)
	tongue.hit.connect(_on_hit, CONNECT_ONE_SHOT)

	await _move_time_to_target(1.0, 0.2)
	_move_camera_to_zoom(orig_zoom, 0.3)
	if tongue.is_done == false:
		await tongue.done

	_clean_up()

func _on_hit(fly: Fly) -> void:
	fly.die()
	Events.hit_letter.emit(fly.letter)

func cancel() -> bool:
	if is_firing == true:
		return false
	_move_camera_to_zoom(orig_zoom, 0.3)
	_move_time_to_target(1.0, 0.2)
	_clean_up()

	return true

func _clean_up() -> void:
	if time_tween != null and time_tween.is_running():
		await time_tween.finished
	
	if camera_tween != null and camera_tween.is_running():
		await camera_tween.finished    
	
	camera.target = Events.game.chameleonardo

	finished.emit()
	queue_free()
