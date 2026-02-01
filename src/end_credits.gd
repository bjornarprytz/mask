extends Node2D
@onready var klara: AudioStreamPlayer = $Klara
@onready var scroll_container: ScrollContainer = %ScrollContainer

func _ready() -> void:
	Audio.continue_theme(preload("res://assets/audio/OneMoreFly - FULL FANFARE.mp3"))
	
	await Audio.play(preload("res://assets/audio/doskogen.wav"))
	await get_tree().create_timer(1.0).timeout
	await Audio.play(preload("res://assets/audio/thank-you-for-playing.wav"))
	

func _process(delta: float) -> void:
	scroll_container.set_deferred("scroll_vertical", scroll_container.scroll_vertical + 2)
