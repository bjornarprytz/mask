class_name Game
extends Node2D

var word_pool: Array[String] = [
	"MASK",
	"FLOWER",
	"CHAMELEON",
]

var current_word: String

@onready var camera: Camera2D = %Camera
@onready var chameleonardo: Chameleonardo = %Chameleonardo
@onready var music: AudioStreamPlayer = %Music
@onready var word_game: WordGame = %WordGame

func _ready() -> void:
	Events.game = self
	current_word = word_pool.pick_random()
	word_game.set_target(current_word)


func _on_word_game_word_completed() -> void:
	Events.game_over.emit()
