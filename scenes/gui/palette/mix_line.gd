extends Control

const LINE_LINK_WIDTH := 10.0
const LINE_PREPARE_MIX_WIDTH := 30.0
const LINE_MAX_WIDTH := 60.0

@export var palette_color_1: Control
@export var palette_color_2: Control
@export var color_id: Globals.COLOR_ID
var line_width := 0.0
var previous_linked_state := false
var is_linked := false

func _draw() -> void:
	if palette_color_1 and palette_color_2:
		draw_line(
			palette_color_1.global_position - global_position,
			palette_color_2.global_position - global_position,
			Globals.COLORS[color_id], line_width, true
		)

func _process(_delta: float) -> void:
	if palette_color_1 and palette_color_2:
		is_linked = palette_color_1.percentage > 0.33 and palette_color_2.percentage > 0.33
		if is_linked == true and previous_linked_state == false:
			tween_line_width(LINE_LINK_WIDTH)
		elif is_linked == false and previous_linked_state == true:
			tween_line_width(0.0)
		previous_linked_state = is_linked
	if visible:
		queue_redraw()

func tween_line_width(new_line_width: float):
	var tween = create_tween()
	tween.tween_property(self, "line_width", new_line_width, 0.25) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func set_highlight(is_highlighted):
	if not is_linked: return
	if is_highlighted:
		modulate = Color.WHITE
		tween_line_width(LINE_PREPARE_MIX_WIDTH)
	else:
		modulate = Color(Color.WHITE, 90.0/255)
		tween_line_width(LINE_LINK_WIDTH)
		
