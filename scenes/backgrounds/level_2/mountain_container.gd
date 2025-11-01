extends Node2D

const MOUNTAIN_DRAWING = preload("uid://dwo4xwjnyvykl")

const MOUNTAIN_OFFSCREEN_Y_DISTANCE = 300

const SPEED := 30.0
const SPAWN_MOUNTAIN_TIMER_MAX := 1.2

const INITIAL_MOUNTAIN_COUNT := 10

var spawn_mountain_timer = SPAWN_MOUNTAIN_TIMER_MAX

func _ready() -> void:
	for i in INITIAL_MOUNTAIN_COUNT:
		var y_offset = Globals.STAGE_HEIGHT * float(INITIAL_MOUNTAIN_COUNT - i)/INITIAL_MOUNTAIN_COUNT
		new_mountain(create_mountain_position(false, y_offset + randf() * 30))
		new_mountain(create_mountain_position(true, y_offset + randf() * 30))

func _process(delta: float) -> void:
	spawn_mountain_timer -= delta
	if spawn_mountain_timer <= 0:
		spawn_mountain_timer += SPAWN_MOUNTAIN_TIMER_MAX
		new_mountain(create_mountain_position(false))
		new_mountain(create_mountain_position(true))
	
	for mountain in get_children():
		mountain.position.y += SPEED * mountain.scale.y * delta
		if mountain.position.y > Globals.STAGE_HEIGHT + MOUNTAIN_OFFSCREEN_Y_DISTANCE:
			mountain.queue_free()

func create_mountain_position(is_on_right: bool = false, y_offset: float = 0) -> Vector2:
	var x_position = (randf()**2)*250
	if is_on_right:
		x_position = Globals.STAGE_WIDTH - x_position
	var y_position = y_offset - MOUNTAIN_OFFSCREEN_Y_DISTANCE
	return Vector2(x_position, y_position)

func new_mountain(mountain_position: Vector2) -> void:
	var mountain = MOUNTAIN_DRAWING.instantiate()
	mountain.position = mountain_position
	add_child(mountain)
	move_child(mountain, 0)
