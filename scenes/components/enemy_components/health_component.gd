class_name HealthComponent extends Node

const HEART_TEXTURE = preload("uid://ca7ucvqcibr7o")
const HEALTH_UNIT_WIDTH = 12.0
@export var max_health: int = 1
@export var free_parent_on_defeat: bool = true
@onready var health = max_health

@onready var heart_container: HBoxContainer = $HeartContainer

signal defeated

func _ready() -> void:
	for i in max_health:
		var heart_texture = HEART_TEXTURE.instantiate()
		heart_container.add_child(heart_texture)

func attack(amount: int):
	health -= amount
	for i in min(amount, heart_container.get_child_count()):
		heart_container.get_child(i).queue_free()
	if health <= 0:
		defeated.emit()
		if free_parent_on_defeat:
			get_parent().queue_free() #might need to change to adapt to other enemy needs?
