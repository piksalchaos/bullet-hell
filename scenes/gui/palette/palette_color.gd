extends Control

@export var color_id: GameProperties.COLOR_ID
@export var percentage := 0.0:
	set = set_percentage
@export var radius := 30.0:
	set = set_radius
@onready var color_component: ColorComponent = $ColorCircle/ColorComponent
@onready var circle_outline: Node2D = $CircleOutline
@onready var color_circle: Node2D = $ColorCircle
const CIRCLE_OUTLINE_WIDTH = 2.0
const TWEEN_DURATION = 0.1

func _ready() -> void:
	color_component.color_id = color_id

func set_percentage(new_percentage):
	percentage = new_percentage
	var tween = get_tree().create_tween()
	tween.tween_property(
		color_circle,
		"radius",
		(circle_outline.radius+CIRCLE_OUTLINE_WIDTH) * new_percentage,
		TWEEN_DURATION
	)

func set_radius(new_radius):
	radius = new_radius
	circle_outline.radius = new_radius
	color_circle.radius = (circle_outline.radius+CIRCLE_OUTLINE_WIDTH) * percentage
