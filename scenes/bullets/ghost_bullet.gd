extends Node2D

@export var speed := 250.0
@export var initial_color_id: GameProperties.COLOR_ID
@onready var color_component: ColorComponent = $ColorComponent

func _ready() -> void:
	color_component.color_id = initial_color_id

func _physics_process(delta: float) -> void:
	position += Vector2(cos(rotation), sin(rotation)) * speed * delta
