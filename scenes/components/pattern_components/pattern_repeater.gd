extends Node2D

@export var seconds_per_shot: float = 0.1
@export var max_shots: int = 0

@onready var timer: Timer = $Timer
var shots_fired: int = 0

func _ready() -> void:
	timer.wait_time = seconds_per_shot

func begin() -> void:
	shoot()
	timer.start()

func stop() -> void:
	timer.stop()

func _on_timer_timeout() -> void:
	shoot()

func shoot() -> void:
	for emitter in get_children():
		if emitter.is_in_group("pattern_components"):
			emitter.begin()
	shots_fired += 1
	if max_shots > 0 and shots_fired >= max_shots:
		shots_fired = 0
		stop()
