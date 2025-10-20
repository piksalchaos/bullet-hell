extends Node

@onready var stage: Node2D = $Stage
@onready var bullet_container: Node2D = $Stage/BulletContainer
@onready var enemy_container: Node2D = $Stage/EnemyContainer
@onready var round_manager: Node2D = $Stage/RoundManager
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
	round_manager.begin()

func _on_player_got_hit() -> void:
	player_health -= 1
	if player_health < 0:
		get_tree().call_deferred("reload_current_scene")
	hud.update_life_heart_count(player_health)

func _on_round_manager_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
