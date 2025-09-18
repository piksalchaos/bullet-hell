extends Node

const STAGE_WIDTH := 486
const STAGE_HEIGHT := 648

const LAYER_PLAYER := 1
const LAYER_ENEMY_HITBOXES := 2
const LAYER_PLAYER_BULLETS := 3
const LAYER_ENEMY_BULLETS := 4

var player_position: Vector2
var bullet_container: Node

func update_player_position(position: Vector2):
	player_position = position

func set_bullet_container(node: Node):
	bullet_container = node
