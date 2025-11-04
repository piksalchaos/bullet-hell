extends Node2D

@onready var color_component: ColorComponent = $ColorComponent
@onready var music_bullet_drawing: Node2D = $MusicBulletDrawing

@export var initial_color_id: Globals.COLOR_ID
@export var cos_radian_offset := 0.0
@export var speed = 160.0
@export var cos_radians_speed := 1.5

var cos_radians := 0.0

func _ready() -> void:
	color_component.set_color_id(initial_color_id)

func _physics_process(delta: float) -> void:
	var velocity_rotation = cos(cos_radians + cos_radian_offset)
	position += Vector2(cos(rotation), sin(rotation)).rotated(velocity_rotation) * speed * delta
	cos_radians += cos_radians_speed * delta
	music_bullet_drawing.set_velocity_rotation(velocity_rotation)
