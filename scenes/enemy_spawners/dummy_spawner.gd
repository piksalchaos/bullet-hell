extends Marker2D

const DUMMY_ENEMY = preload("uid://dn0cnxlnduxm7")

@export var initial_color_id: Globals.COLOR_ID

func begin() -> void:
	var enemy = DUMMY_ENEMY.instantiate()
	enemy.position = Vector2(position.x, -100)
	enemy.starting_position = position
	enemy.initial_color_id = initial_color_id
	Globals.enemy_container.add_child(enemy)
	enemy.tree_exited.connect(queue_free)
