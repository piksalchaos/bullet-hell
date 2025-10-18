extends Control

@export var color_id: Globals.COLOR_ID
@export var percentage := 0.0:
	set = set_percentage
@export var radius := 30.0:
	set = set_radius
@onready var color_component: ColorComponent = $PaletteColorVisual/ColorComponent
@onready var circle_outline: Node2D = $CircleOutline
@onready var palette_color_visual: Node2D = $PaletteColorVisual
const CIRCLE_OUTLINE_WIDTH = 2.0
const TWEEN_DURATION = 0.1

func _ready() -> void:
	color_component.set_color_id(color_id)

func set_percentage(new_percentage):
	percentage = new_percentage
	palette_color_visual.has_spikes = new_percentage*3 >= 3
	var tween = get_tree().create_tween()
	tween.tween_property(
		palette_color_visual,
		"radius",
		(circle_outline.radius + CIRCLE_OUTLINE_WIDTH) * new_percentage,
		TWEEN_DURATION
	)
	#
	#tween.tween_property(
		#palette_color_visual,
		#"intensity",
		#int(floor(new_percentage*3)) * 0.2,
		#TWEEN_DURATION
	#)

func set_radius(new_radius):
	radius = new_radius
	circle_outline.radius = new_radius
	percentage = percentage #this might make it tween the color_cirlce radius while changing radius, but that's okay
	#color_circle.radius = (circle_outline.radius+CIRCLE_OUTLINE_WIDTH) * percentage 
