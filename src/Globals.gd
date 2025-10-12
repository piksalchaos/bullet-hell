extends Node

const STAGE_WIDTH := 486
const STAGE_HEIGHT := 648

func get_position_relative_to_stage(global_position: Vector2):
	return global_position - stage_position

enum COLOR_ID {RED, ORANGE, YELLOW, GREEN, BLUE, PURPLE, WHITE}
const PRIMARY_COLORS: Array[COLOR_ID] = [COLOR_ID.RED, COLOR_ID.YELLOW, COLOR_ID.BLUE]
const SECONDARY_COLOR_MAP: Dictionary = {
	COLOR_ID.ORANGE: [COLOR_ID.RED, COLOR_ID.YELLOW],
	COLOR_ID.GREEN: [COLOR_ID.YELLOW, COLOR_ID.BLUE],
	COLOR_ID.PURPLE: [COLOR_ID.BLUE, COLOR_ID.RED]
}
const COLORS: Array[Color] = [
	Color(0.98, 0.255, 0.255, 1.0),
	Color(1.0, 0.61, 0.22, 1.0),
	Color(1.0, 0.99, 0.41, 1.0),
	Color(0.46, 1.0, 0.46, 1.0),
	Color(0.24, 0.24, 1.0, 1.0),
	Color(0.625, 0.25, 1.0, 1.0),
	Color.WHITE
]

const LAYER_PLAYER := 1
const LAYER_ENEMY_HITBOXES := 2
const LAYER_PLAYER_BULLETS := 3
const LAYER_ENEMY_BULLETS := 4

var stage_position: Vector2
var player_position: Vector2
var bullet_container: Node2D
var enemy_container: Node2D

#var color_absorption: Array[float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
#var selected_color := 0

func update_player_position(position: Vector2):
	player_position = position
