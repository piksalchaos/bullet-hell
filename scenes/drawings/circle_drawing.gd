extends Node2D

@export var radius: float = 2:
	set = set_radius

func _draw():
	draw_circle(Vector2.ZERO, radius, Color.WHITE)

func set_radius(new_radius):
	radius = new_radius
	queue_redraw()
