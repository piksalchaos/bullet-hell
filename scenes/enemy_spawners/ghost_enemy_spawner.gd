extends Marker2D

const GHOST_ENEMY = preload("res://scenes/entities/enemies/ghost_enemy.tscn")

func begin() -> void:
	var enemy = GHOST_ENEMY.instantiate()
	enemy.position = Vector2(position.x, -100)
	enemy.starting_position = position
	GameProperties.enemy_container.add_child(enemy)
	enemy.tree_exited.connect(queue_free)
