extends Control

@export var color_id: Globals.COLOR_ID
@export var percentage := 0.0:
	set = set_percentage
@export var radius := 30.0:
	set = set_radius
@onready var circle_outline: Node2D = $CircleOutline
@onready var inner_circle_outline: Node2D = $InnerCircleOutline
@onready var inner_circle_outline_2: Node2D = $InnerCircleOutline2
@onready var circle_fill: Node2D = $CircleFill
@onready var palette_color_visual: Node2D = $PaletteColorVisual
@onready var highlight: Node2D = $Highlight
@onready var highlight_outer: Node2D = $Highlight/HighlightOuter
@onready var highlight_inner: Node2D = $Highlight/HighlightInner
@onready var highlight_color_component: ColorComponent = $Highlight/HighlightColorComponent
const CIRCLE_OUTLINE_WIDTH = 2.0
const TWEEN_DURATION = 0.1

func _ready() -> void:
	#highlight_color_component.set_color_id(color_id)
	change_to_original_color()

func change_color(new_color_id):
	$PaletteColorVisual/ColorComponent.set_color_id_with_tween(new_color_id)
	$CircleFill/ColorComponent.set_color_id_with_tween(new_color_id)
	$InnerCircleOutline/ColorComponent.set_color_id_with_tween(new_color_id)
	$InnerCircleOutline2/ColorComponent.set_color_id_with_tween(new_color_id)

func change_to_original_color():
	change_color(color_id)

func saturate_highlight_color():
	highlight_color_component.set_color_id_with_tween(color_id)

func desaturate_highlight_color():
	highlight_color_component.set_color_id_with_tween(Globals.COLOR_ID.WHITE)

func set_percentage(new_percentage):
	percentage = new_percentage
	palette_color_visual.has_spikes = new_percentage*3 >= 3
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(
		palette_color_visual,
		"radius",
		(circle_outline.radius + CIRCLE_OUTLINE_WIDTH) * new_percentage,
		TWEEN_DURATION
	)
	var fill_lightness = floor(new_percentage*3) * 0.15
	tween.tween_property(
		circle_fill,
		"self_modulate",
		Color(Color(fill_lightness, fill_lightness, fill_lightness)),
		TWEEN_DURATION
	)
	var highlight_lightness = (floor(new_percentage*3)+1) * 0.05
	highlight_color_component.alpha = highlight_lightness

func set_radius(new_radius):
	radius = new_radius
	circle_outline.radius = new_radius
	inner_circle_outline.radius = new_radius / 3
	inner_circle_outline_2.radius = new_radius / 3 * 2
	
	circle_fill.radius = new_radius
	highlight_outer.radius = new_radius * 1.3
	highlight_inner.radius = new_radius * 1.15
	percentage = percentage #this might make it tween the color_cirlce radius while changing radius, but that's okay
	#color_circle.radius = (circle_outline.radius+CIRCLE_OUTLINE_WIDTH) * percentage 

func set_highlight(is_highlighted):
	highlight.visible = is_highlighted
