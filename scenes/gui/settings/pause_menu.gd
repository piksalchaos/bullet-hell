extends PanelContainer

@onready var vine_boom_audio: AudioStreamPlayer = $VineBoomAudio
@onready var settings_menu: PanelContainer = $"../SettingsMenu"

signal ready_to_restart

func _on_back_button_pressed() -> void:
	hide()
	get_tree().paused = false

func _on_restart_button_pressed() -> void:
	ready_to_restart.emit()
	hide()
	get_tree().paused = false

func _on_settings_button_pressed() -> void:
	settings_menu.show()

func _on_vine_boom_button_pressed() -> void:
	vine_boom_audio.play()
