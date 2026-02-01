class_name WordGame
extends PanelContainer
@onready var letters: HBoxContainer = %Letters

signal word_completed()

func _ready() -> void:
	Events.hit_letter.connect(_on_hit_letter)

func _on_hit_letter(letter: String) -> void:
	for child in letters.get_children():
		if child.text == letter.to_upper() and not child.is_scored:
			child.score(Events.game.chameleonardo.modulate)
			break
	
	for child in letters.get_children():
		if not child.is_scored:
			return
	
	word_completed.emit()
	
func set_target(word: String):
	self.show()
	for child in letters.get_children():
		await child.end()
	for c in word:
		var block = preload("res://letter_block.tscn").instantiate() as LetterBlock
		block.text = c.to_upper()
		await get_tree().create_timer(.1).timeout
		letters.add_child(block)
