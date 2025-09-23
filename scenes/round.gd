class_name Round extends Node2D

var enemy_count = 0

signal enemies_defeated

func begin() -> void:
	for spawner in get_children():
		enemy_count += 1
		var enemy: Node2D = spawner.create_enemy()
		enemy.tree_exited.connect(decrement_enemy_count)

func decrement_enemy_count() -> void:
	enemy_count -= 1
	if enemy_count <= 0:
		enemies_defeated.emit()
