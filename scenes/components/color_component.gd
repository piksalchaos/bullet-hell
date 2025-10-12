class_name ColorComponent extends Node

const TWEEN_DURATION = 0.2
@export var color_id: Globals.COLOR_ID
@export var alpha := 1.0
@onready var parent = get_parent()

var disabled = false

func _ready():
	parent.modulate = Color(Globals.COLORS[color_id], alpha)

func set_color_id(new_color_id):
	color_id = new_color_id
	if parent:
		parent.modulate = get_color()

func set_color_id_with_tween(new_color_id, tween_duration = TWEEN_DURATION):
	color_id = new_color_id
	if parent:
		var tween = get_tree().create_tween()
		tween.tween_property(parent, "modulate", get_color(), tween_duration)

func get_color() -> Color:
	return Color(Globals.COLORS[color_id], alpha)

func disable() -> void:
	disabled = true
	set_color_id_with_tween(Globals.COLOR_ID.WHITE)
