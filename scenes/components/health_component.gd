class_name HealthComponent extends Node

@export var max_health: int = 1
@onready var health = max_health

func attack(amount: int):
	health -= amount
	if health <= 0:
		get_parent().queue_free() #might need to change to adapt to other enemy needs?
