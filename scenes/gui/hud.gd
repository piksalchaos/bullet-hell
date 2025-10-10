extends Control

const LIFE_HEART = preload("uid://cg285sbaifnvs")
@onready var life_heart_container: HBoxContainer = $RightBar/LifeHeartContainer

func update_life_heart_count(life_heart_count: int) -> void:
	if life_heart_count < 0: return
	var container_child_count = life_heart_container.get_child_count()
	if container_child_count < life_heart_count:
		for i in (life_heart_count - container_child_count):
			var life_heart = LIFE_HEART.instantiate()
			life_heart_container.add_child(life_heart)
	elif life_heart_container.get_child_count() > life_heart_count:
		for i in (container_child_count - life_heart_count):
			life_heart_container.get_child(i).queue_free()
