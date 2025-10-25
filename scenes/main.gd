extends Node

const LEVEL_1 = preload("uid://bp24suxtg5xp5")

@onready var start_menu: Control = $StartMenu
@onready var pause_menu: PanelContainer = $SettingsLayer/PauseMenu

func _on_start_menu_ready_to_begin() -> void:
	start_menu.queue_free()
	var level_1 = LEVEL_1.instantiate()
	add_child(level_1)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = not get_tree().paused
		if get_tree().paused:
			pause_menu.show()
		else:
			pause_menu.hide()
