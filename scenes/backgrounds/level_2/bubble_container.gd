extends Node2D

const BUBBLE_DRAWING = preload("uid://cft6p7t11ie53")

const BUBBLE_OFFSCREEN_DISTANCE = 50

const SPEED := 30.0
const SPAWN_BUBBLE_TIMER_MAX := 1.1

var spawn_bubble_timer = SPAWN_BUBBLE_TIMER_MAX

func _ready() -> void:
	for i in 60:
		var y_offset = i * 15
		new_bubble(create_bubble_position(y_offset))

func _process(delta: float) -> void:
	spawn_bubble_timer -= delta
	if spawn_bubble_timer <= 0:
		spawn_bubble_timer += SPAWN_BUBBLE_TIMER_MAX
		new_bubble(create_bubble_position(false))
		new_bubble(create_bubble_position(true))
	
	for bubble in get_children():
		if (
			bubble.position.y > Globals.STAGE_HEIGHT + BUBBLE_OFFSCREEN_DISTANCE
			or bubble.position.x < -BUBBLE_OFFSCREEN_DISTANCE
			or bubble.position.x > Globals.STAGE_WIDTH + BUBBLE_OFFSCREEN_DISTANCE
		):
			bubble.queue_free()

func create_bubble_position(y_offset: float = 0) -> Vector2:
	var x_position = randf() * Globals.STAGE_WIDTH
	var y_position = y_offset - BUBBLE_OFFSCREEN_DISTANCE
	return Vector2(x_position, y_position)

func new_bubble(bubble_position: Vector2) -> void:
	var bubble = BUBBLE_DRAWING.instantiate()
	bubble.position = bubble_position
	add_child(bubble)
