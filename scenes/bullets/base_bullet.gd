extends Node2D

@export var speed := 250.0

func _physics_process(delta: float) -> void:
	position += Vector2(cos(rotation), sin(rotation)) * speed * delta
