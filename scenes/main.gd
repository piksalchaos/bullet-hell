extends Node

const LEVEL_1 = preload("uid://bp24suxtg5xp5")

@onready var start_menu: Control = $StartMenu
@onready var settings_menu: PanelContainer = $SettingsLayer/SettingsMenu

func _on_start_menu_ready_to_begin() -> void:
	start_menu.queue_free()
	var level_1 = LEVEL_1.instantiate()
	add_child(level_1)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = not get_tree().paused
		if get_tree().paused:
			settings_menu.show()
		else:
			settings_menu.hide()
