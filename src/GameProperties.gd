extends Node

const STAGE_WIDTH := 486
const STAGE_HEIGHT := 648

enum COLOR_ID {RED, ORANGE, YELLOW, GREEN, BLUE, PURPLE}
const COLORS: Array[Color] = [
	Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.BLUE, Color.PURPLE
]

const LAYER_PLAYER := 1
const LAYER_ENEMY_HITBOXES := 2
const LAYER_PLAYER_BULLETS := 3
const LAYER_ENEMY_BULLETS := 4

var player_position: Vector2
var bullet_container: Node2D
var enemy_container: Node2D
var captured_color_ids: Array[COLOR_ID]

func update_player_position(position: Vector2):
	player_position = position
