extends Node2D

const SPRITE_ROTATION_SPEED = 1.0
const VERTICAL_SPEED = 125.0
const HORIZONTAL_SPEED = 60.0

@export var initial_color_id: Globals.COLOR_ID
var sin_offset_angle = 0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var color_component: ColorComponent = $ColorComponent

func _ready() -> void:
	color_component.set_color_id(initial_color_id)
	sprite_2d.rotation = randf() * 2 * PI
	sin_offset_angle = randf() * 2 * PI

func _physics_process(delta: float) -> void:
	sin_offset_angle += delta
	if sin_offset_angle > 2 * PI:
		sin_offset_angle -= 2 * PI
	position.y += VERTICAL_SPEED * delta
	position.x += HORIZONTAL_SPEED * delta * sin(sin_offset_angle)
	
	sprite_2d.rotation += SPRITE_ROTATION_SPEED * delta
