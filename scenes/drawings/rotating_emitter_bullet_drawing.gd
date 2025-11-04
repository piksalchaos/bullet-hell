extends Node2D

const MIN_RADIUS := 16.0
const MAX_RADIUS := 18.0
#var SPEED := 18.0

var radius := MIN_RADIUS

func _ready():
	var tween = create_tween()
	tween.bind_node(self)
	tween.tween_property(self, "radius", MAX_RADIUS, 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "radius", MIN_RADIUS, 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.set_loops()

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.WHITE, true, -1.0, true)

func _process(_delta: float) -> void:
	queue_redraw()
