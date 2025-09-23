class_name ColorComponent extends Node

@export var color_id: GameProperties.COLOR_ID:
	set = set_color_id
@onready var parent: Node2D = get_parent()

func _ready():
	parent.modulate = GameProperties.COLORS[color_id]

func set_color_id(new_color_id):
	color_id = new_color_id
	if parent:
		parent.modulate = GameProperties.COLORS[new_color_id]
