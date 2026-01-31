class_name Stealth
extends Area2D

@onready var shape: CollisionShape2D = %Shape
@onready var visual: Sprite2D = %Visual

var change_tween: Tween

var current_level: int = 0

func set_level(level: int):
	if (level == current_level):
		return
	current_level = level
	_change_size(level * 20.0)

func _change_size(radius: float):
	if (change_tween):
		change_tween.kill()
	
	change_tween = create_tween().set_parallel()
	
	change_tween.tween_property(shape.shape, "radius", radius, 1.0)
	change_tween.tween_property(visual, "scale", Vector2.ONE * (radius / 20.0), 1.0)
