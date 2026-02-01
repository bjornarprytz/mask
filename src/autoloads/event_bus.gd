class_name EventBus
extends Node2D


# Add signals here for game-wide events. Access through the Events singleton
var chars := "abcdefghijklnopqrstuxyzæøå123456789"
enum ControlScheme {
	KEYBOARD,
	GAMEPAD
}

var control_scheme: ControlScheme = ControlScheme.KEYBOARD

var game: Game

signal game_over(win: bool)
signal hit_letter(letter: String)

func get_char():
	if (!game or !game.current_word or game.current_word.length() == 0):
		return chars[randi_range(0, chars.length() - 1)]
	
	return game.current_word[randi_range(0, game.current_word.length() - 1)]
