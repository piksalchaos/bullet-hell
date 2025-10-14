extends Marker2D

const FROLICKER_GHOST_ENEMY = preload("uid://c4h4q8uea4l2x")
@export var color_id: Globals.COLOR_ID
@export var ending_position: Vector2
@export var transition_time: float = 3.0

func begin() -> void:
	var enemy = FROLICKER_GHOST_ENEMY.instantiate()
	enemy.position = Vector2(position.x, -100)
	enemy.starting_position = position
	enemy.ending_position = ending_position
	enemy.transition_time = transition_time
	enemy.initial_color_id = color_id
	Globals.enemy_container.add_child(enemy)
	enemy.tree_exited.connect(queue_free)
