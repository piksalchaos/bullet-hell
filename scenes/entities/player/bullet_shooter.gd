extends Node2D

const PLAYER_BULLET = preload("res://scenes/bullets/player_bullet.tscn")
const CIRCLE_DRAWING = preload("uid://dstuu3qr7iaia")

const CIRCLE_RADIUS := 5.0
const CIRCLE_DISTANCE := 35.0
const CIRCLE_RAD_OFFSET := PI/3
const TWEEN_DURATION := 0.2

func _ready() -> void:
	SignalBus.bullet_captured.connect(add_absorbed_circle)

func add_absorbed_circle(captured_position: Vector2, color_id: GameProperties.COLOR_ID) -> void:
	var circle = CIRCLE_DRAWING.instantiate()
	circle.position = captured_position - get_parent().position
	circle.modulate = GameProperties.COLORS[color_id]
	circle.radius = 0
	add_child(circle)
	var tween = get_tree().create_tween()
	tween.tween_property(circle, "radius", CIRCLE_RADIUS, TWEEN_DURATION)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and GameProperties.captured_color_ids.size() > 0:
		shoot_bullet()

func shoot_bullet():
	var bullet = PLAYER_BULLET.instantiate()
	bullet.initial_color_id = GameProperties.captured_color_ids[0]
	bullet.position = get_parent().position
	GameProperties.bullet_container.add_child(bullet)
	GameProperties.captured_color_ids.pop_back()
	get_child(0).queue_free()

func _on_child_order_changed() -> void:
	update_circle_positions()

func update_circle_positions():
	var color_count = get_child_count()
	var tween = get_tree().create_tween()
	tween.set_parallel()
	for i in color_count:
		print(i)
		tween.tween_property(
			get_child(i),
			"position",
			Vector2.DOWN.rotated((i - (color_count-1)*0.5)*CIRCLE_RAD_OFFSET) * CIRCLE_DISTANCE,
			TWEEN_DURATION
		)
