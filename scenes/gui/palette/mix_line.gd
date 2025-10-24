extends Control

const MAX_WIDTH := 60.0

var palette_color_1: Control
var palette_color_2: Control
var color_id: Globals.COLOR_ID
var line_width := 0.0

func _draw() -> void:
	if palette_color_1 and palette_color_2:
		draw_line(
			palette_color_1.global_position - global_position,
			palette_color_2.global_position - global_position,
			Globals.COLORS[color_id], line_width, true
		)

func _process(_delta: float) -> void:
	if visible:
		queue_redraw()

func show_with_transition(new_palette_color_1, new_palette_color_2, new_color_id):
	palette_color_1 = new_palette_color_1
	palette_color_2 = new_palette_color_2
	color_id = new_color_id
	show()
	var tween = create_tween()
	tween.tween_property(self, "line_width", MAX_WIDTH, 0.3) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func hide_with_transition():
	var tween = create_tween()
	tween.tween_property(self, "line_width", 0.0, 0.2) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(hide)
