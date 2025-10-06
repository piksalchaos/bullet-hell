extends Node2D

@onready var timer: Timer = $Timer
@export var wait_time: float = 1.0

func _ready() -> void:
	timer.wait_time = wait_time

func begin() -> void:
	timer.start()

func _on_timer_timeout() -> void:
	for spawner in get_children():
		if spawner.has_method("begin"):
			spawner.begin()

func _on_child_order_changed() -> void:
	if get_child_count() <= 1:
		queue_free()
