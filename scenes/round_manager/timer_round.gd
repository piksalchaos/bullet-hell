extends Node2D

@onready var timer: Timer = $Timer
@onready var round_spawner: Round = $Round
@export var wait_time: float = 1.0

func _ready() -> void:
	hide()
	timer.wait_time = wait_time

func begin() -> void:
	show()
	if timer.is_inside_tree():
		timer.start()

func _on_timer_timeout() -> void:
	round_spawner.begin()
