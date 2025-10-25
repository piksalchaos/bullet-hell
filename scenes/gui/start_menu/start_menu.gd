extends Control

@onready var black_fade_transition: ColorRect = $BlackFadeTransition

signal ready_to_begin

func _on_begin_button_pressed() -> void:
	black_fade_transition.transition_to_black()

func _on_black_fade_transition_finished_transition() -> void:
	ready_to_begin.emit()
