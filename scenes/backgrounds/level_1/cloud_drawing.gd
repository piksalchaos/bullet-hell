extends Node2D

var rect: Rect2

func _ready():
	rect = Rect2(Vector2.ZERO, Vector2(randf_range(150, 200), randf_range(50, 100)))

func _draw() -> void:
	draw_rect(rect, Color(0.195, 0.0, 0.407, 0.078))
