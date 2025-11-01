extends Node2D

const TREE_DRAWING = preload("uid://djagoqhr17stx")

const TREE_OFFSCREEN_Y_DISTANCE = 200

const SPEED := 30.0
const SPAWN_TREE_TIMER_MAX := 0.45

var spawn_tree_timer = SPAWN_TREE_TIMER_MAX

@onready var tree_container: Node2D = $TreeContainer

func _ready() -> void:
	for i in 60:
		var y_offset = i * 15
		new_tree(create_tree_position(false, y_offset))
		new_tree(create_tree_position(true, y_offset))

func _process(delta: float) -> void:
	spawn_tree_timer -= delta
	if spawn_tree_timer <= 0:
		spawn_tree_timer += SPAWN_TREE_TIMER_MAX
		new_tree(create_tree_position(false))
		new_tree(create_tree_position(true))
	
	for tree in tree_container.get_children():
		tree.position.y += SPEED * tree.scale.y * delta
		if tree.position.y > Globals.STAGE_HEIGHT + TREE_OFFSCREEN_Y_DISTANCE:
			tree.queue_free()

func create_tree_position(is_on_right: bool = false, y_offset: float = 0) -> Vector2:
	var x_position = (randf()**2)*250
	if is_on_right:
		x_position = Globals.STAGE_WIDTH - x_position
	var y_position = y_offset - TREE_OFFSCREEN_Y_DISTANCE
	return Vector2(x_position, y_position)

func new_tree(tree_position: Vector2) -> void:
	var tree = TREE_DRAWING.instantiate()
	tree.position = tree_position
	tree_container.add_child(tree)
