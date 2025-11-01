extends Node2D

const STEM_WIDTH := 6.0
@export var radius: float = 10.0

var velocity_rotation := 0.0

func _draw():
	draw_circle(Vector2.ZERO, radius, Color.WHITE, true, -1, true)
	var y_position = -velocity_rotation * (radius - STEM_WIDTH/2)
	draw_line(Vector2(0, y_position), Vector2(-16, y_position), Color.WHITE, STEM_WIDTH, true)
	draw_line(Vector2(-16, y_position), Vector2(-13, y_position*2), Color.WHITE, STEM_WIDTH, true)
	draw_circle(Vector2(-16, y_position), STEM_WIDTH/2, Color.WHITE, true, -1, true)
	draw_circle(Vector2(-13, y_position*2), STEM_WIDTH/2 - 0.2, Color.WHITE, true, -1, true)


func set_velocity_rotation(new_velocity_rotation: float):
	velocity_rotation = new_velocity_rotation
	queue_redraw()
