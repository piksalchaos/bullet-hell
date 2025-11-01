extends Node

const START_MENU = preload("uid://c8n3kh1ff5dg1")
const LEVEL_1 = preload("uid://bp24suxtg5xp5")
const LEVEL_2 = preload("uid://bcx57y8kx223d")

var levels = [LEVEL_1, LEVEL_2]
@export var current_level_index = 0

@onready var start_menu: Control = $StartMenu
@onready var settings_menu: PanelContainer = $SettingsLayer/SettingsMenu
@onready var pause_menu: PanelContainer = $SettingsLayer/PauseMenu
@onready var level_container: Node = $LevelContainer

func create_start_menu():
	if is_instance_valid(start_menu): return
	current_level_index = 0
	start_menu = START_MENU.instantiate()
	start_menu.ready_to_begin.connect(_on_start_menu_ready_to_begin)
	start_menu.ready_to_open_settings.connect(_on_start_menu_ready_to_open_settings)
	add_child(start_menu)

func is_playing_level():
	return level_container.get_child_count() > 0

func start_level():
	for child in level_container.get_children():
		child.queue_free()
	var level = levels[current_level_index].instantiate()
	level.finished.connect(_on_level_finished)
	level.game_ended.connect(_on_level_game_ended)
	level_container.add_child(level)

func _on_start_menu_ready_to_begin() -> void:
	start_menu.queue_free()
	start_level()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and is_playing_level() and not settings_menu.visible:
			get_tree().paused = not get_tree().paused
			pause_menu.visible = get_tree().paused

func _on_start_menu_ready_to_open_settings() -> void:
	settings_menu.show()

func _on_pause_menu_ready_to_restart() -> void:
	start_level()

func _on_level_finished() -> void:
	current_level_index += 1
	if current_level_index < levels.size():
		start_level()
	else:
		create_start_menu()

func _on_level_game_ended() -> void:
	create_start_menu()

func _on_pause_menu_ready_to_exit_to_start_menu() -> void:
	level_container.get_child(0).end_game()
