extends Control

const LINE_LINK_WIDTH := 7.5
const LINE_PREPARE_MIX_WIDTH := 20.0
const LINE_MAX_WIDTH := 60.0
const INACTIVE_ALPHA := 0.35

@export var palette_color_1: Control
@export var palette_color_2: Control
@export var color_id: Globals.COLOR_ID
#var line_width := 0.0
var previous_linked_state := false
var is_linked := false
var is_highlighted := false
var is_mixing := false

var previous_line_width := 0.0

var previous_alpha := 0.0

#var point_1: Vector2
#var point_2: Vector2
@onready var line: Line2D = $Container/Line
@onready var color_component: ColorComponent = $Container/ColorComponent
@onready var container: Node2D = $Container



func _ready():
	color_component.set_color_id(color_id)

func _process(_delta: float) -> void:
	if palette_color_1 and palette_color_2:
		is_linked = palette_color_1.percentage > 0.33 and palette_color_2.percentage > 0.33
		var line_width = get_current_line_width()
		if line_width != previous_line_width:
			tween_line_width(line_width)
		previous_line_width = line_width
		
		var alpha = get_current_alpha()
		if alpha != previous_alpha:
			tween_alpha(alpha)
		previous_alpha = alpha
	line.points[0] = palette_color_1.global_position - global_position
	line.points[1] = palette_color_2.global_position - global_position
	
	if is_mixing:
		container.position = Globals.get_random_vector_factor() * 2
	else:
		container.position = Vector2.ZERO

func get_current_line_width() -> float:
	if is_mixing:
		return LINE_MAX_WIDTH
	if is_linked:
		if is_highlighted:
			return LINE_PREPARE_MIX_WIDTH
		return LINE_LINK_WIDTH
	return 0.0

func get_current_alpha() -> float:
	if is_highlighted or is_mixing:
		return 1
	return INACTIVE_ALPHA

func tween_line_width(new_line_width: float):
	var tween = create_tween()
	tween.tween_property(line, "width", new_line_width, 0.25) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func tween_alpha(new_alpha: float):
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(Color.WHITE, new_alpha), 0.25) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func set_highlight(new_is_highlighted):
	is_highlighted = new_is_highlighted
		
func set_is_mixing(new_is_mixing: bool):
	is_mixing = new_is_mixing
