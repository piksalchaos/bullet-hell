extends PanelContainer

@onready var vine_boom_audio: AudioStreamPlayer = $VineBoomAudio
@onready var settings_menu: PanelContainer = $"../SettingsMenu"

#signal ready_to_restart
signal ready_to_exit_to_start_menu

func _on_back_button_pressed() -> void:
	hide()
	get_tree().paused = false

#func _on_restart_button_pressed() -> void:
	#ready_to_restart.emit()
	#hide()
	#get_tree().paused = false

func _on_settings_button_pressed() -> void:
	settings_menu.show()

func _on_vine_boom_button_pressed() -> void:
	vine_boom_audio.play()

func _on_exit_button_pressed() -> void:
	ready_to_exit_to_start_menu.emit()
	hide()
	get_tree().paused = false
