extends Node

@onready var bullet_container: Node2D = $Stage/BulletContainer
@onready var enemy_container: Node2D = $Stage/EnemyContainer
@onready var round_manager: Node2D = $Stage/RoundManager
@onready var hud: Control = $HUD
@onready var player: Player = $Stage/Player

@export var max_player_health := 3
var player_health = 0

func _ready() -> void:
	GameProperties.captured_color_ids = []
	GameProperties.bullet_container = bullet_container
	GameProperties.enemy_container = enemy_container

func start_game():
	player_health = max_player_health
	player.is_active = true
	hud.update_life_heart_count(player_health)
	round_manager.begin()

func _on_hud_start_button_pressed() -> void:
	start_game()

func _on_player_got_hit() -> void:
	player_health -= 1
	if player_health < 0:
		get_tree().call_deferred("reload_current_scene")
	hud.update_life_heart_count(player_health)
