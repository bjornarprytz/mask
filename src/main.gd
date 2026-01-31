class_name Game
extends Node2D

@onready var camera: Camera2D = %Camera
@onready var chameleonardo: Chameleonardo = %Chameleonardo
@onready var music: AudioStreamPlayer = %Music


func _ready() -> void:
	Events.game = self

func _process(delta: float) -> void:
	camera.global_position = lerp(camera.global_position, chameleonardo.global_position, delta)
