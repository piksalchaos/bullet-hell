extends Path2D

const SMALL_GHOST_ENEMY = preload("uid://lo3vyw11povn")
const FOLLOWER_ENEMY_PATH = preload("uid://c1thepo2x4ww5")

@export var color_id: Globals.COLOR_ID
@export var number_of_enemies: int = 3
@export var time_between_spawns: float = 0.5

func begin() -> void:
	var enemy_path = FOLLOWER_ENEMY_PATH.instantiate()
	enemy_path.curve = curve
	enemy_path.enemy_scene = SMALL_GHOST_ENEMY
	enemy_path.initial_color_id = color_id
	enemy_path.number_of_enemies = number_of_enemies
	enemy_path.time_between_spawns = time_between_spawns
	
	Globals.enemy_container.add_child(enemy_path)
	enemy_path.tree_exited.connect(queue_free)
