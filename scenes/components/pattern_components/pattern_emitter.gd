extends Node2D

func begin() -> void:
	shoot()

func shoot() -> void:
	for emitter in get_children():
		if emitter.is_in_group("pattern_components"):
			emitter.begin()
