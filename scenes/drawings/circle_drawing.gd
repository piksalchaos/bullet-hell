extends Node2D

@export var radius: float = 2:
	set = set_radius
@export var is_filled := true
@export var line_width := -1.0

func _draw():
	if is_filled:
		draw_circle(Vector2.ZERO, radius, Color.WHITE, true, -1.0, true)
	else:
		draw_circle(Vector2.ZERO, radius, Color.WHITE, false, line_width, true)

func set_radius(new_radius):
	radius = new_radius
	queue_redraw()
