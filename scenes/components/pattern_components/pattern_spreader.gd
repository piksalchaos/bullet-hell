extends Node2D

@export_range(0, 2*PI) var angle_range: float = PI*0.25
@export var bullet_count: int = 3

func begin() -> void:
	for i in bullet_count:
		rotation = -angle_range/2 + i*(angle_range/(bullet_count-1))
		shoot()

func shoot() -> void:
	for emitter in get_children():
		if emitter.is_in_group("pattern_components"):
			emitter.begin()
