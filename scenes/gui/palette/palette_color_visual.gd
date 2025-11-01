extends Node2D

const ROTATION_SPEED := 0.5
const POINT_COUNT := 24
@export var radius: float = 0:
	set = set_radius
@export var has_spikes: bool = false:
	set = set_has_spikes
@export var color: Color = Color.WHITE

func _draw():
	if has_spikes:
		draw_colored_polygon(get_polygon_points(), color)
	else:
		draw_circle(Vector2.ZERO, radius, color, true, -1.0, true)

func _process(delta: float) -> void:
	if has_spikes:
		rotation += ROTATION_SPEED * delta

func get_polygon_points():
	var points = []
	for i in POINT_COUNT:
		var point_distance = radius if i % 2 == 0 else radius * 1.2
		var x = cos(2*PI*float(i)/POINT_COUNT) * point_distance
		var y = sin(2*PI*float(i)/POINT_COUNT) * point_distance
		points.append(Vector2(x, y))
	return points

func set_radius(new_radius):
	radius = new_radius
	queue_redraw()

func set_has_spikes(new_has_spikes):
	has_spikes = new_has_spikes
	queue_redraw()
