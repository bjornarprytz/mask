class_name EventBus
extends Node2D


# Add signals here for game-wide events. Access through the Events singleton

enum ControlScheme {
    KEYBOARD,
    GAMEPAD
}

var control_scheme: ControlScheme = ControlScheme.KEYBOARD

var game: Game

signal game_over(win: bool)
