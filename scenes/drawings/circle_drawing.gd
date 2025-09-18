extends Node2D

@export var radius: float = 2

func _draw():
	draw_circle(Vector2.ZERO, radius, Color.WHITE)
