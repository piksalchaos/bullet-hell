extends Node2D

@onready var tree_leaves_drawing: Node2D = $TreeLeavesDrawing
@onready var trunk_sprite: Sprite2D = $TrunkSprite

func _ready() -> void:
	trunk_sprite.frame = randi_range(0, 3)
	scale = Vector2(1, 1) * randf_range(0.5, 1)
