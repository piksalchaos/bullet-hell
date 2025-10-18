extends Control

const RANDOM_INTENSITY = 20.0
const POLYGON_COLOR = Color(Color.WHITE, 0.3)

func _draw():
	for i in range(1, 5):
		draw_colored_polygon(get_polygon_points(60*i, 60*i, 16), POLYGON_COLOR)

func get_polygon_points(x_radius: float, y_radius: float, point_count: int):
	var random_angle = randf() * 2 * PI
	var points = []
	for i in point_count:
		var x = cos(2*PI*float(i)/point_count + random_angle) * x_radius + (randf()-0.5)*RANDOM_INTENSITY
		var y = sin(2*PI*float(i)/point_count + random_angle) * y_radius + (randf()-0.5)*RANDOM_INTENSITY
		points.append(Vector2(x, y))
	return points


func _on_redraw_timer_timeout() -> void:
	queue_redraw()
