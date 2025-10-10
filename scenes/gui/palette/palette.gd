extends Control

const CENTER_DISTANCE = 70.0
const SELECTED_CENTER_DISTANCE = 115.0
const RADIUS = 45.0
const SELECTED_RADIUS = 85.0
const TWEEN_DURATION = 0.35

const PALETTE_COLOR = preload("uid://cnfbbe0r3do7e")
@onready var color_container: Control = $ColorContainer
var selected_primary_color_index: int = 0
var rotation_factor: int = 0

func _ready() -> void:
	SignalBus.color_amount_changed.connect(_on_color_amount_changed)
	SignalBus.selected_color_changed.connect(_on_selected_color_changed)
	for i in Globals.PRIMARY_COLORS.size():
		var palette_color = PALETTE_COLOR.instantiate()
		palette_color.color_id = Globals.PRIMARY_COLORS[i]
		color_container.add_child(palette_color)
		var angle = i * PI*(2.0/3) - PI/2
		if i == selected_primary_color_index:
			palette_color.position = Vector2(cos(angle), sin(angle)) * SELECTED_CENTER_DISTANCE
			palette_color.radius = SELECTED_RADIUS
		else:
			palette_color.position = Vector2(cos(angle), sin(angle)) * CENTER_DISTANCE
			palette_color.radius = RADIUS

func _on_color_amount_changed(primary_color_index, percentage):
	color_container.get_child(primary_color_index).percentage = percentage

func _on_selected_color_changed(primary_color_index):
	var primary_color_count = Globals.PRIMARY_COLORS.size()
	var cw_offset = (primary_color_index - selected_primary_color_index + primary_color_count) % primary_color_count
	var ccw_offset = (selected_primary_color_index - primary_color_index + primary_color_count) % primary_color_count
	if ccw_offset < cw_offset:
		rotation_factor += ccw_offset
	else:
		rotation_factor -= cw_offset
		
	var tween = get_tree().create_tween()
	tween.tween_property(color_container, "rotation", rotation_factor * PI*(2.0/3), TWEEN_DURATION) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.set_parallel()
	
	var selected_color = color_container.get_child(primary_color_index)
	var previous_selected_color = color_container.get_child(selected_primary_color_index)
	#
	tween.tween_property(selected_color, "radius", SELECTED_RADIUS, TWEEN_DURATION) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(selected_color, "position", selected_color.position.normalized() * SELECTED_CENTER_DISTANCE, TWEEN_DURATION) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	if primary_color_index != selected_primary_color_index:
		var other_tween = get_tree().create_tween()
		other_tween.tween_property(previous_selected_color, "radius", RADIUS, TWEEN_DURATION) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		other_tween.set_parallel()
		other_tween.tween_property(previous_selected_color, "position", previous_selected_color.position.normalized() * CENTER_DISTANCE, TWEEN_DURATION) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	selected_primary_color_index = primary_color_index
