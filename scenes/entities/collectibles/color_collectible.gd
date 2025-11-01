extends Node2D

const INITIAL_Y_VELOCITY = -100
const MAX_Y_VELOCITY = 200
const Y_ACCELERATION = 150

var y_velocity = INITIAL_Y_VELOCITY

@export var initial_color_id: Globals.COLOR_ID
@onready var color_component: ColorComponent = $ColorComponent

func _ready():
	color_component.set_color_id(initial_color_id)

func _process(delta: float) -> void:
	position.y += y_velocity * delta
	y_velocity += Y_ACCELERATION * delta
	if y_velocity > MAX_Y_VELOCITY: y_velocity = MAX_Y_VELOCITY

func _on_collectible_component_collected() -> void:
	SignalBus.collected_color_collectible.emit(color_component.color_id)
