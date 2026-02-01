class_name Game
extends Node2D

var word_pool: Array[String] = [
	"ZEN",
	"MASK",
	"INSECT",
	"SLOWLY",
	"FLOWER",
	"INSECT",
	"MONSTERA",
	"CHAMELEON",
]

var current_word: String

@onready var camera: Camera2D = %Camera
@onready var chameleonardo: Chameleonardo = %Chameleonardo
@onready var word_game: WordGame = %WordGame

func _ready() -> void:
	Events.game = self
	current_word = word_pool.pick_random()
	word_pool.erase(current_word)
	word_game.set_target(current_word)
	
	Audio.continue_theme(preload("res://assets/audio/OneMoreFly - tromme og bass.mp3"))


func _on_word_game_word_completed() -> void:

	if word_pool.size() == 0:
		Events.game_over.emit(true)
		return
	current_word = word_pool.pick_random()
	word_pool.erase(current_word)
	word_game.set_target(current_word)
