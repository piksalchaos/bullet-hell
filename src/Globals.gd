extends Node

const STAGE_WIDTH := 576
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
	Color(1.0, 0.506, 0.22, 1.0),
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

var score: int = 0:
	set = set_score

func set_score(value):
	score = value
	SignalBus.score_updated.emit(value)

var stage_position: Vector2
var player_position: Vector2
var bullet_container: Node2D
var enemy_container: Node2D
var collectible_container: Node2D
var background_container: Node2D

var max_player_health: int = 1
var player_health: int = max_player_health:
	set = set_player_health

func set_player_health(value):
	player_health = value
	SignalBus.player_health_changed.emit(value)

func update_player_position(position: Vector2):
	player_position = position

func get_random_vector_factor():
	var angle = randf() * 2 * PI
	return Vector2(cos(angle), sin(angle)) * randf() * 0.5

func clear_all_bullets():
	for bullet in bullet_container.get_children():
		bullet.queue_free()
