class_name HitboxComponent extends Area2D

@export var health_component: HealthComponent
@export var color_id: Globals.COLOR_ID

func hit(damage: int, bullet_color_id: Globals.COLOR_ID):
	if not health_component or color_id != bullet_color_id: return
	health_component.attack(damage)
