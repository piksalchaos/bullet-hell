extends Control

@onready var main_screen: Control = $MainScreen
@onready var select_screen: Control = $SelectScreen
@onready var black_fade_transition: ColorRect = $BlackFadeTransition
var selected_difficulty: String = ""
var is_on_main_screen := true

signal ready_to_begin(difficulty: String)
signal ready_to_open_settings

func _ready() -> void:
	black_fade_transition.transition_to_transparent()

func _on_begin_button_pressed() -> void:
	is_on_main_screen = false
	black_fade_transition.transition_to_black()

func _on_back_button_pressed() -> void:
	is_on_main_screen = true
	black_fade_transition.transition_to_black()

func _on_black_fade_transition_finished_transition() -> void:
	if black_fade_transition.is_transparent: return
	if selected_difficulty != "":
		ready_to_begin.emit(selected_difficulty)
		return
	black_fade_transition.transition_to_transparent()
	main_screen.visible = is_on_main_screen
	select_screen.visible = not is_on_main_screen

func _on_settings_button_pressed() -> void:
	ready_to_open_settings.emit()

func _on_easy_button_pressed() -> void:
	selected_difficulty = "easy"
	black_fade_transition.transition_to_black()

func _on_normal_button_pressed() -> void:
	selected_difficulty = "normal"
	black_fade_transition.transition_to_black()

func _on_hard_button_pressed() -> void:
	selected_difficulty = "hard"
	black_fade_transition.transition_to_black()

func _on_tutorial_button_toggled(toggled_on: bool) -> void:
	Globals.is_tutorial_on = toggled_on
