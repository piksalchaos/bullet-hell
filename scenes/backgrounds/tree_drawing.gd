extends Node2D

const TREE_RECT_COUNT := 16
const TREE_RECT_POSITION_VARIATION := Vector2(70, 50)
const TREE_RECT_SIZE := Vector2(40, 25)
const TREE_RECT_SIZE_VARIATION := Vector2(20, 15)
const TREE_RECT_COLOR := Color(0.512, 0.0, 0.143, 0.04)

const TREE_TRUNK_POSITION_OFFSET :=  Vector2(5, 10)
const TREE_TRUNK_SIZE := Vector2(10, 60)
const TREE_TRUNK_COLOR := Color(0.12, 0.0, 0.006, 0.8)

const REPOSITION_TIMER_WAIT_TIME := 2.0

var color: Color = TREE_RECT_COLOR + Color((randf()-0.5) * 0.3, 0, (randf()-0.5) * 0.15, 0)
var rects: Array[Rect2] = []

@onready var reposition_timer: Timer = $RepositionTimer

func _ready() -> void:
	reposition_timer.start(randf() * REPOSITION_TIMER_WAIT_TIME)
	for i in TREE_RECT_COUNT:
		var rect = Rect2(
			TREE_RECT_POSITION_VARIATION * Globals.get_random_vector_factor(),
			TREE_RECT_SIZE + TREE_RECT_SIZE_VARIATION * Globals.get_random_vector_factor()
		)
		rects.append(rect)

func _draw() -> void:
	#draw_rect(Rect2(TREE_TRUNK_POSsITION_OFFSET, TREE_TRUNK_SIZE), TREE_TRUNK_COLOR, true)
	for rect: Rect2 in rects:
		draw_rect(rect, color, true)

func _on_reposition_timer_timeout() -> void:
	reposition_timer.wait_time = REPOSITION_TIMER_WAIT_TIME
	position += Globals.get_random_vector_factor() * 3.5
