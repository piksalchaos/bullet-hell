extends Node2D

@export var radius: float = 45.0

const CIRCLE_AMOUNT = 3

func _draw() -> void:
	for i in CIRCLE_AMOUNT:
		var circle_radius = radius/CIRCLE_AMOUNT * (i+1)
		var circle_color = Color(Color.WHITE, 0.2/(CIRCLE_AMOUNT+1 - i))
		draw_circle(Vector2.ZERO, circle_radius, circle_color, true, -1, true)
	#draw_circle(Vector2.ZERO, radius, Color(Color.WHITE, 0.3), false, 1, true)
