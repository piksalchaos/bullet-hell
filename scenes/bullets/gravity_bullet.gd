extends Node2D

@export var initial_speed := 400.0
@export var max_speed := 800
@export var initial_color_id: Globals.COLOR_ID
@export var acceleration: Vector2 = Vector2(0, 400)
@onready var color_component: ColorComponent = $ColorComponent

var velocity: Vector2

func _ready() -> void:
	color_component.set_color_id(initial_color_id)
	velocity = Vector2(cos(rotation), sin(rotation)) * initial_speed

func _physics_process(delta: float) -> void:
	position += velocity * delta
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	else:
		velocity += acceleration * delta
	
