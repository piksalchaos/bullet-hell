extends Node2D

const COLOR_COLLECTIBLE = preload("uid://b10er0vdastih")

@export var color_component: ColorComponent
@export var health_component: HealthComponent

func _ready() -> void:
	health_component.defeated.connect(_on_health_component_defeated)

func _on_health_component_defeated():
	var collectible = COLOR_COLLECTIBLE.instantiate()
	collectible.position = Globals.get_position_relative_to_stage(global_position)
	collectible.initial_color_id = color_component.color_id
	Globals.collectible_container.call_deferred("add_child", collectible)
