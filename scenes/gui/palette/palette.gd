extends Control

const CENTER_DISTANCE = 80.0
const SELECTED_CENTER_DISTANCE = 140.0
const RADIUS = 30.0
const SELECTED_RADIUS = 65.0
const TWEEN_DURATION = 0.35

const PALETTE_COLOR = preload("uid://cnfbbe0r3do7e")
var selected_color_id: int = 0
var rotation_factor: int = 0

func _ready() -> void:
	SignalBus.color_amount_changed.connect(_on_color_amount_changed)
	SignalBus.selected_color_changed.connect(_on_selected_color_changed)
	for i in GameProperties.COLOR_ID.size() - 1:
		var palette_color = PALETTE_COLOR.instantiate()
		var angle = i * PI/3 - PI/2
		palette_color.position = Vector2(cos(angle), sin(angle)) * CENTER_DISTANCE
		palette_color.color_id = i
		add_child(palette_color)

func _on_color_amount_changed(color_id, percentage):
	get_child(color_id).percentage = percentage

func _on_selected_color_changed(color_id):
	print(color_id)
	var tween = get_tree().create_tween()
	var color_count = GameProperties.COLOR_ID.size()
	var cw_difference = (color_id - selected_color_id + color_count) % color_count
	var ccw_difference = (selected_color_id - color_id + color_count) % color_count
	
	if cw_difference < ccw_difference:
		rotation_factor -= cw_difference
	else:
		rotation_factor += ccw_difference
	
	tween.tween_property(self, "rotation", rotation_factor * PI/3, TWEEN_DURATION) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.set_parallel()
	
	var selected_color = get_child(color_id)
	var previous_selected_color = get_child(selected_color_id)
	
	tween.tween_property(selected_color, "radius", SELECTED_RADIUS, TWEEN_DURATION) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(selected_color, "position", selected_color.position.normalized() * SELECTED_CENTER_DISTANCE, TWEEN_DURATION) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	if color_id != selected_color_id:
		var other_tween = get_tree().create_tween()
		other_tween.tween_property(previous_selected_color, "radius", RADIUS, TWEEN_DURATION) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		other_tween.set_parallel()
		other_tween.tween_property(previous_selected_color, "position", previous_selected_color.position.normalized() * CENTER_DISTANCE, TWEEN_DURATION) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	selected_color_id = color_id
	
