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
const CIRCLE_OUTLINE_WIDTH = 2.0
const TWEEN_DURATION = 0.1

func _ready() -> void:
	change_to_original_color()

func change_color(new_color_id):
	$PaletteColorVisual/ColorComponent.set_color_id_with_tween(new_color_id)
	$CircleFill/ColorComponent.set_color_id_with_tween(new_color_id)
	$InnerCircleOutline/ColorComponent.set_color_id_with_tween(new_color_id)
	$InnerCircleOutline2/ColorComponent.set_color_id_with_tween(new_color_id)

func change_to_original_color():
	change_color(color_id)

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
	var lightness = floor(new_percentage*3) * 0.15
	tween.tween_property(
		circle_fill,
		"self_modulate",
		Color(Color(lightness, lightness, lightness)),
		TWEEN_DURATION
	)

func set_radius(new_radius):
	radius = new_radius
	circle_outline.radius = new_radius
	inner_circle_outline.radius = new_radius / 3
	inner_circle_outline_2.radius = new_radius / 3 * 2
	
	circle_fill.radius = new_radius
	highlight.radius = new_radius + 24
	percentage = percentage #this might make it tween the color_cirlce radius while changing radius, but that's okay
	#color_circle.radius = (circle_outline.radius+CIRCLE_OUTLINE_WIDTH) * percentage 

func set_highlight(is_highlighted):
	highlight.visible = is_highlighted

#func set_prepare_mix(is_preparing_mix):
	#var lightness = 0.3 if is_preparing_mix else 1.0
	#var tween = create_tween()
	#tween.tween_property(self, "modulate", Color(lightness, lightness, lightness, 1.0), 0.3) \
		#.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
