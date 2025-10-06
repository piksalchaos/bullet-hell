extends Control

@export var color_id: GameProperties.COLOR_ID
@export var percentage := 0.0:
	set = set_percentage
@onready var color_component: ColorComponent = $ColorCircle/ColorComponent
@onready var circle_outline: Node2D = $CircleOutline
@onready var color_circle: Node2D = $ColorCircle
const TWEEN_DURATION = 0.1

func _ready() -> void:
	color_component.color_id = color_id

func set_percentage(new_percentage):
	print(new_percentage)
	percentage = new_percentage
	var tween = get_tree().create_tween()
	tween.tween_property(color_circle, "radius", (circle_outline.radius+2) * new_percentage, TWEEN_DURATION)
