extends Node2D

@export var collectible_scene: PackedScene
@export var health_component: HealthComponent

func _ready() -> void:
	health_component.defeated.connect(_on_health_component_defeated)

func _on_health_component_defeated():
	var collectible = collectible_scene.instantiate()
	collectible.position = Globals.get_position_relative_to_stage(global_position)
	Globals.collectible_container.call_deferred("add_child", collectible)
