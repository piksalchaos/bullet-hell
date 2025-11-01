extends Control

const CENTER_DISTANCE = 100.0
const SELECTED_CENTER_DISTANCE = 150.0
const MIX_CENTER_DISTANCE = 160.0
const RADIUS = 60.0
const SELECTED_RADIUS = 110.0
const TWEEN_DURATION = 0.35

const PALETTE_COLOR = preload("uid://cnfbbe0r3do7e")
const MIX_LINE = preload("uid://bbou5jm73pq6i")

@onready var color_container: Control = $ColorContainer
@onready var mix_line_container: Control = $MixLineContainer
var selected_primary_color_index: int = 0
var rotation_factor: int = 0
var vibration_amount: float = 0

func _ready() -> void:
	SignalBus.color_amount_changed.connect(_on_color_amount_changed)
	SignalBus.selected_color_changed.connect(_on_selected_color_changed)
	SignalBus.mixed_colors_changed.connect(_on_mixed_colors_changed)
	SignalBus.found_color_to_mix_changed.connect(_on_found_color_to_mix_changed)
	SignalBus.cannot_perform_color_action.connect(_on_cannot_perform_color_action)
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
	for secondary_color_id in Globals.SECONDARY_COLOR_MAP.keys():
		var mix_line = MIX_LINE.instantiate()
		mix_line.color_id = secondary_color_id
		
		var primary_color_index_1 = Globals.PRIMARY_COLORS.find(Globals.SECONDARY_COLOR_MAP[secondary_color_id][0])
		var primary_color_index_2 = Globals.PRIMARY_COLORS.find(Globals.SECONDARY_COLOR_MAP[secondary_color_id][1])
		
		mix_line.palette_color_1 = color_container.get_child(primary_color_index_1)
		mix_line.palette_color_2 = color_container.get_child(primary_color_index_2)
		
		mix_line_container.add_child(mix_line)

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

func _on_mixed_colors_changed(mixed_primary_color_index):
	for palette_color in color_container.get_children():
		palette_color.set_highlight(
			palette_color.get_index() == mixed_primary_color_index
		)
	for mix_line in mix_line_container.get_children():
		var primary_color_id = Globals.PRIMARY_COLORS[mixed_primary_color_index]
		mix_line.set_highlight(
			false if mixed_primary_color_index == -1
			else Globals.SECONDARY_COLOR_MAP[mix_line.color_id].has(primary_color_id)
		)
#
func _on_found_color_to_mix_changed(found_color_to_mix: bool, color_id: Globals.COLOR_ID):
	if found_color_to_mix:
		var first_primary_color_index = Globals.PRIMARY_COLORS.find(Globals.SECONDARY_COLOR_MAP[color_id][0])
		var second_primary_color_index = Globals.PRIMARY_COLORS.find(Globals.SECONDARY_COLOR_MAP[color_id][1])
		mix_line.show_with_transition(
			color_container.get_child(first_primary_color_index),
			color_container.get_child(second_primary_color_index),
			color_id
		)
	else:
		mix_line.hide_with_transition()

func _on_cannot_perform_color_action():
	vibration_amount = 8.0

func _process(delta: float) -> void:
	if vibration_amount > 0:
		color_container.position.x = vibration_amount * (randf()-0.5)
		vibration_amount -= 30 * delta
		if vibration_amount <= 0.5:
			vibration_amount = 0
