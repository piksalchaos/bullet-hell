class_name HitboxComponent extends Area2D

@export var health_component: HealthComponent

func hit(damage: int):
	if not health_component: return
	health_component.attack(damage)
