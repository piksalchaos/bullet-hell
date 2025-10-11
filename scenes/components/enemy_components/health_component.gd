class_name HealthComponent extends Node

@export var max_health: int = 1
@onready var health = max_health

@onready var healthbar: ProgressBar = $Healthbar

func _ready() -> void:
	healthbar.max_value = max_health
	healthbar.value = health
	healthbar.size.x = 16 + max_health * 8
	healthbar.position.x = -healthbar.size.x/2

func attack(amount: int):
	health -= amount
	healthbar.value = health
	if health <= 0:
		get_parent().queue_free() #might need to change to adapt to other enemy needs?
