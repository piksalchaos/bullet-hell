extends Node

@export_multiline var japanese_text: String = ""
var english_text: String

func _ready() -> void:
	english_text = get_parent().text
	change_language(Globals.is_japanese)
	SignalBus.language_changed.connect(change_language)

func change_language(is_japanese: bool):
	get_parent().text = japanese_text if is_japanese else english_text
