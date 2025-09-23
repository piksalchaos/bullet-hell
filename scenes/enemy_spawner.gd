extends Marker2D

const ENEMY = preload("res://scenes/entities/enemy.tscn")

func create_enemy() -> Enemy:
	var enemy = ENEMY.instantiate()
	enemy.position = Vector2(position.x, -100)
	enemy.starting_position = position
	GameProperties.enemy_container.add_child(enemy)
	return enemy
