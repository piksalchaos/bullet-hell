extends Control

@export var color_id: Globals.COLOR_ID
@export var percentage := 0.0:
	set = set_percentage
@export var radius := 30.0:
	set = set_radius
@onready var circle_outline: Node2D = $CircleOutline
@onready var circle_fill: Node2D = $CircleFill
@onready var palette_color_visual: Node2D = $PaletteColorVisual
@onready var highlight_outline: Node2D = $HighlightOutline
const CIRCLE_OUTLINE_WIDTH = 2.0
const TWEEN_DURATION = 0.1

func _ready() -> void:
	$PaletteColorVisual/ColorComponent.set_color_id(color_id)
	$CircleFill/ColorComponent.set_color_id(color_id)

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
	tween.tween_property(
		circle_fill,
		"self_modulate",
		Color(Color.WHITE, (floor(new_percentage*3)) * 0.15),
		TWEEN_DURATION
	)

func set_radius(new_radius):
	radius = new_radius
	circle_outline.radius = new_radius
	circle_fill.radius = new_radius
	highlight_outline.radius = new_radius + 12
	percentage = percentage #this might make it tween the color_cirlce radius while changing radius, but that's okay
	#color_circle.radius = (circle_outline.radius+CIRCLE_OUTLINE_WIDTH) * percentage 

func set_highlight(is_highlighted):
	highlight_outline.visible = is_highlighted
