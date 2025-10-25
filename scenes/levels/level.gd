extends Node

@onready var stage: Node2D = $Stage
@onready var bullet_container: Node2D = $Stage/BulletContainer
@onready var enemy_container: Node2D = $Stage/EnemyContainer
@onready var round_sequencer: Node2D = $Stage/RoundSequencer
@onready var hud: Control = $HUD
@onready var player: Player = $Stage/Player

@export var max_player_health := 4
var player_health = 0

func _ready() -> void:
	Globals.bullet_container = bullet_container
	Globals.enemy_container = enemy_container
	Globals.stage_position = stage.position
	start_game()

func start_game():
	player_health = max_player_health
	player.is_active = true
	hud.update_life_heart_count(player_health)
	round_sequencer.begin()

func _on_player_got_hit() -> void:
	player_health -= 1
	if player_health < 0:
		get_tree().call_deferred("reload_current_scene")
	hud.update_life_heart_count(player_health)

func _on_round_sequencer_tree_exiting() -> void:
		get_tree().change_scene_to_file("res://scenes/start_menu.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = not get_tree().paused
		if get_tree().paused:
			hud.show_pause_menu()
		else:
			hud.hide_pause_menu()
