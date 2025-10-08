extends Node

const STAGE_WIDTH := 486
const STAGE_HEIGHT := 648

enum COLOR_ID {RED, ORANGE, YELLOW, GREEN, BLUE, PURPLE, WHITE}
const PRIMARY_COLORS: Array[COLOR_ID] = [COLOR_ID.RED, COLOR_ID.YELLOW, COLOR_ID.BLUE]
const SECONDARY_COLOR_MAP: Dictionary = {
	COLOR_ID.ORANGE: [COLOR_ID.RED, COLOR_ID.YELLOW],
	COLOR_ID.GREEN: [COLOR_ID.YELLOW, COLOR_ID.BLUE],
	COLOR_ID.PURPLE: [COLOR_ID.BLUE, COLOR_ID.RED]
}
const COLORS: Array[Color] = [
	Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.BLUE, Color.PURPLE, Color.WHITE
]

const LAYER_PLAYER := 1
const LAYER_ENEMY_HITBOXES := 2
const LAYER_PLAYER_BULLETS := 3
const LAYER_ENEMY_BULLETS := 4

var player_position: Vector2
var bullet_container: Node2D
var enemy_container: Node2D

#var color_absorption: Array[float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
#var selected_color := 0

func update_player_position(position: Vector2):
	player_position = position
