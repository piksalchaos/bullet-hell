extends Node2D

const TREE_RECT_COUNT := 16
const TREE_RECT_POSITION_VARIATION := Vector2(200, 100)
const TREE_RECT_SIZE := Vector2(60, 50)
const TREE_RECT_SIZE_VARIATION := Vector2(20, 15)
const TREE_RECT_COLOR := Color(0.19, 0.0, 0.0, 0.25)

var rects: Array[Rect2] = []
var color: Color

func _ready() -> void:
	color = TREE_RECT_COLOR
	color.ok_hsl_h -= randf()*0.1
	for i in TREE_RECT_COUNT:
		var rect = Rect2(
			TREE_RECT_POSITION_VARIATION * Globals.get_random_vector_factor() - TREE_RECT_SIZE/2,
			TREE_RECT_SIZE + TREE_RECT_SIZE_VARIATION * Globals.get_random_vector_factor()
		)
		rects.append(rect)

func _draw() -> void:
	for rect: Rect2 in rects:
		draw_rect(rect, color, true)
