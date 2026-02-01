extends Node2D

@onready var audio: AudioStreamPlayer = %Audio
@onready var logo: TextureRect = %Logo

var splash_tween : Tween

func _ready() -> void:
	splash_tween = create_tween()
	splash_tween.tween_property(logo, "modulate:a", 1.0, 2.0).from(0.0)
	await splash_tween.finished
	audio.play()
	await audio.finished
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://entry.tscn")

func _input(event: InputEvent) -> void:
	if (event is InputEventKey or event is InputEventMouseButton):
		splash_tween.kill()
		get_tree().change_scene_to_file("res://entry.tscn")
		
