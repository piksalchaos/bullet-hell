extends Node2D

@export var delay_time: float = 0
@export var seconds_per_shot: float = 0.1
@export var max_shots: int = 0

@onready var delay_timer: Timer = $DelayTimer
@onready var timer: Timer = $Timer
var shots_fired: int = 0

func begin() -> void:
	timer.wait_time = seconds_per_shot
	if delay_time <= 0:
		_on_delay_timer_timeout()
	else:
		delay_timer.wait_time = delay_time
		delay_timer.start()

func stop() -> void:
	delay_timer.stop()
	timer.stop()

func _on_delay_timer_timeout() -> void:
	shoot()
	timer.start()

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
