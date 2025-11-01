class_name ColorComponent extends Node

const TWEEN_DURATION = 0.2
@export var color_id: Globals.COLOR_ID
@export var alpha := 1.0:
	set = set_alpha
@onready var parent = get_parent()

var disabled = false

func _ready():
	parent.modulate = Color(Globals.COLORS[color_id], alpha)

func set_alpha(value):
	alpha = value
	parent.modulate.a = alpha
	

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

func subtract_colors(primary_color_indices):
	for primary_color_index in primary_color_indices:
		var color_to_subtract = Globals.PRIMARY_COLORS[primary_color_index]
		var is_primary = Globals.PRIMARY_COLORS.has(color_id)
		if is_primary:
			if color_id == color_to_subtract:
				disable()
		else:
			var map_primary_index = Globals.SECONDARY_COLOR_MAP[color_id].find(color_to_subtract)
			if map_primary_index != -1:
				set_color_id_with_tween(Globals.SECONDARY_COLOR_MAP[color_id][0 if map_primary_index == 1 else 1])
