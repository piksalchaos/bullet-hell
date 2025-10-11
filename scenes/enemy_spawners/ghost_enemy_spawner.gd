extends Marker2D

const GHOST_ENEMY = preload("res://scenes/entities/enemies/ghost_enemy.tscn")

#@export var exit_time: float = 8
@export var color_id: Globals.COLOR_ID

func begin() -> void:
	var enemy = GHOST_ENEMY.instantiate()
	enemy.position = Vector2(position.x, -100)
	enemy.starting_position = position
	#enemy.exit_time = exit_time
	enemy.initial_color_id = color_id
	Globals.enemy_container.add_child(enemy)
	enemy.tree_exited.connect(queue_free)
