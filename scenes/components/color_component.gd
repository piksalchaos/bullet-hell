class_name ColorComponent extends Node

const TWEEN_DURATION = 0.2
@export var color_id: GameProperties.COLOR_ID:
	set = set_color_id
@onready var parent = get_parent()

var disabled = false

func _ready():
	parent.modulate = GameProperties.COLORS[color_id]

func set_color_id(new_color_id):
	color_id = new_color_id
	if parent:
		parent.modulate = GameProperties.COLORS[new_color_id]

func disable() -> void:
	disabled = true
	var tween = get_tree().create_tween()
	tween.tween_property(parent, "modulate", Color.WHITE, TWEEN_DURATION)
