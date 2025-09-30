extends Node2D

const PLAYER_BULLET = preload("res://scenes/bullets/player_bullet.tscn")
const CIRCLE_DRAWING = preload("uid://dstuu3qr7iaia")

const CIRCLE_RADIUS := 5.0
const TWEEN_DURATION = 0.2

func _ready() -> void:
	SignalBus.bullet_captured.connect(add_absorbed_bullet)

func add_absorbed_bullet(captured_position: Vector2, color_id: GameProperties.COLOR_ID) -> void:
	var circle = CIRCLE_DRAWING.instantiate()
	circle.position = captured_position - get_parent().position
	circle.modulate = GameProperties.COLORS[color_id]
	circle.radius = 0
	add_child(circle)
	var tween = get_tree().create_tween()
	tween.tween_property(circle, "radius", CIRCLE_RADIUS, TWEEN_DURATION)
