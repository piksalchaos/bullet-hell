extends Node2D

func begin() -> void:
	shoot()

func shoot() -> void:
	rotation = (Globals.player_position - Globals.get_position_relative_to_stage(global_position)).angle()
	for emitter in get_children():
		if emitter.is_in_group("pattern_components"):
			emitter.begin()
