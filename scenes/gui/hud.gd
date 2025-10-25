extends Control

const LIFE_HEART = preload("uid://cg285sbaifnvs")
@onready var life_heart_container: HBoxContainer = $RightBar/LifeHeartContainer
@onready var pause_menu: PanelContainer = $BattleAreaReference/PauseMenu

func update_life_heart_count(new_life_heart_count: int) -> void:
	if new_life_heart_count < 0: return
	#var container_child_count = life_heart_container.get_child_count()
	var life_heart_count = 0
	for life_heart in life_heart_container.get_children():
		if not life_heart.destroyed: life_heart_count += 1
	
	if life_heart_count < new_life_heart_count:
		for i in (new_life_heart_count - life_heart_count):
			var life_heart = LIFE_HEART.instantiate()
			life_heart_container.add_child(life_heart)
	elif life_heart_count > new_life_heart_count:
		for i in (life_heart_count - new_life_heart_count):
			life_heart_container.get_child(life_heart_count - 1 - i).destroy()

func show_pause_menu() -> void:
	pause_menu.show()

func hide_pause_menu() -> void:
	pause_menu.hide()
