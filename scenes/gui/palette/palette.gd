extends Control

const CENTER_DISTANCE = 80.0
const RADIUS = 30.0
const SELECTED_RADIUS = 50.0
const LINE_WIDTH = 2

const PALETTE_COLOR = preload("uid://cnfbbe0r3do7e")
var selected_color_id = 0

func _ready() -> void:
	SignalBus.color_amount_changed.connect(_on_color_amount_changed)
	SignalBus.selected_color_changed.connect(_on_selected_color_changed)
	for i in GameProperties.COLOR_ID.size():
		var palette_color = PALETTE_COLOR.instantiate()
		var angle = i * PI/3 - PI/2
		palette_color.position = Vector2(cos(angle), sin(angle)) * CENTER_DISTANCE
		palette_color.color_id = i
		add_child(palette_color)

func _on_color_amount_changed(color_id, percentage):
	get_child(color_id).percentage = percentage

func _on_selected_color_changed(color_id):
	var tween = get_tree().create_tween()
	var new_rotation = -color_id * PI/3
	var color_count = GameProperties.COLOR_ID.size()
	if (selected_color_id + color_count - color_id) < (selected_color_id + color_id):
		new_rotation = -color_id * PI/3 + 2*PI
	tween.tween_property(self, "rotation", new_rotation, 0.35).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
