extends Node2D

@onready var color_component: ColorComponent = $ColorComponent

@export var initial_color_id: Globals.COLOR_ID
@export var cos_radian_offset := 0.0
@export var speed = 160.0
@export var cos_radians_speed := 1.5

var cos_radians := 0.0

func _ready() -> void:
	color_component.set_color_id(initial_color_id)

func _physics_process(delta: float) -> void:
	position += Vector2(cos(rotation), sin(rotation)).rotated(cos(cos_radians + cos_radian_offset)) * speed * delta
	cos_radians += cos_radians_speed * delta
