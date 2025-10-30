extends Control

@onready var black_fade_transition: ColorRect = $BlackFadeTransition
var is_transitioning := false

signal ready_to_begin
signal ready_to_open_settings

func _ready() -> void:
	black_fade_transition.transition_to_transparent()

func _on_begin_button_pressed() -> void:
	black_fade_transition.transition_to_black()
	is_transitioning = true

func _on_black_fade_transition_finished_transition() -> void:
	if not black_fade_transition.is_transparent:
		ready_to_begin.emit()
		is_transitioning = false

func _on_settings_button_pressed() -> void:
	ready_to_open_settings.emit()
