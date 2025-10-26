extends Node2D

const TREE_DRAWING = preload("uid://djagoqhr17stx")

const TREE_OFFSCREEN_Y_DISTANCE = 200

const SPEED := 32.0
const SPAWN_TREE_TIMER_MAX := 0.5

var spawn_tree_timer = SPAWN_TREE_TIMER_MAX

@onready var tree_container: Node2D = $TreeContainer

func _ready() -> void:
	for i in 60:
		var tree_position = Vector2((randf()**2)*250, (randf()- 0.5)*100 + i * 15 - TREE_OFFSCREEN_Y_DISTANCE)
		new_tree(tree_position)
		var tree_position_2 = Vector2(Globals.STAGE_WIDTH - (randf()**2)*250, (randf()- 0.5)*100 + i * 15 - TREE_OFFSCREEN_Y_DISTANCE)
		new_tree(tree_position_2)
	

func _process(delta: float) -> void:
	spawn_tree_timer -= delta
	if spawn_tree_timer <= 0:
		spawn_tree_timer += SPAWN_TREE_TIMER_MAX
		var tree_position = Vector2((randf()**2)*250, (randf()- 0.5)*100 - TREE_OFFSCREEN_Y_DISTANCE)
		new_tree(tree_position)
		var tree_position_2 = Vector2(Globals.STAGE_WIDTH - (randf()**2)*250, (randf()- 0.5)*100 - TREE_OFFSCREEN_Y_DISTANCE)
		new_tree(tree_position_2)
	for tree in tree_container.get_children():
		tree.position.y += SPEED * delta
		if tree.position.y > Globals.STAGE_HEIGHT + TREE_OFFSCREEN_Y_DISTANCE:
			tree.queue_free()
			print(tree)

func new_tree(tree_position: Vector2) -> void:
	var tree = TREE_DRAWING.instantiate()
	tree.position = tree_position
	tree_container.add_child(tree)
