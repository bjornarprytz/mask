class_name LetterBlock
extends RichTextLabel

var is_scored: bool = false

func _ready() -> void:
	scale.y = 0.0
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale:y", 1.0, .4)

func score(color: Color) -> Tween:
	is_scored = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", color, .5)
	return tween

func end() -> Tween:
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale:y", 0.0, .2)
	tween.tween_callback(queue_free)
	return tween
	
