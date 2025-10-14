extends Node2D

@export_range(0, 2*PI) var angle_range: float = 0.2

func begin() -> void:
	shoot()

func shoot() -> void:
	rotation = (randf()-0.5) * angle_range
	for emitter in get_children():
		if emitter.is_in_group("pattern_components"):
			emitter.begin()
