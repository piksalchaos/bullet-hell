extends Node2D

@onready var timer: Timer = $Timer
@onready var round_spawner: Round = $Round
@export var wait_time: float = 1.0
@export var is_disabled: bool = false

func _ready() -> void:
	hide()
	timer.wait_time = wait_time
	round_spawner.is_disabled = is_disabled

func begin() -> void:
	show()
	if timer.is_inside_tree():
		timer.start()

func _on_timer_timeout() -> void:
	round_spawner.begin()
