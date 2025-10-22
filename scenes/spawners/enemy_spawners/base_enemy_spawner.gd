extends Marker2D

@export var enemy_scene: PackedScene
@export var color_id: Globals.COLOR_ID

func begin() -> void:
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(position.x, -100)
	enemy.starting_position = position
	enemy.initial_color_id = color_id
	Globals.enemy_container.add_child(enemy)
	enemy.tree_exited.connect(queue_free)
