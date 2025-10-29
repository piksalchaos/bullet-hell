extends Node

const FOGGY_BACKGROUND = preload("uid://bd3idbrv612oi")

func begin() -> void:
	var background = FOGGY_BACKGROUND.instantiate()
	Globals.background_container.add_child(background)
	queue_free()
