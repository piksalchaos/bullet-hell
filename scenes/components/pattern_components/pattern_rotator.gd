extends Node2D

@export_range(0, 2*PI) var angle_range: float = PI*0.25
@export var cycle_bullet_count: int = 3
@export var cycle_index = 0
@export var is_ping_pong: bool = false
@export var is_rotating_ccw: bool = true

func begin() -> void:
	rotation = -angle_range/2 + angle_range*(float(cycle_index) / (cycle_bullet_count-1))
	shoot()
	cycle_index += 1 if is_rotating_ccw else -1
	if cycle_index >= cycle_bullet_count and is_rotating_ccw:
		if is_ping_pong:
			is_rotating_ccw = false
			cycle_index -= 1
		else:
			cycle_index = 0
	elif cycle_index <= -1 and not is_rotating_ccw:
		if is_ping_pong:
			is_rotating_ccw = true
			cycle_index += 1
		else:
			cycle_index = cycle_bullet_count - 1
	print(cycle_index)

func shoot() -> void:
	for emitter in get_children():
		if emitter.is_in_group("pattern_components"):
			emitter.begin()
