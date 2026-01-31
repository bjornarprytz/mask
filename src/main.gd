class_name Game
extends Node2D

@onready var camera: Camera2D = %Camera
@onready var chameleonardo: Chameleonardo = %Chameleonardo
@onready var music: AudioStreamPlayer = %Music


func _ready() -> void:
	Events.game = self
