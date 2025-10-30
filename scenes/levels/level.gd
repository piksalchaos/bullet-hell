extends Node

@onready var black_fade_transition: ColorRect = $BlackFadeTransition
@onready var stage: Node2D = $Stage
@onready var bullet_container: Node2D = $Stage/BulletContainer
@onready var enemy_container: Node2D = $Stage/EnemyContainer
@onready var collectible_container: Node2D = $Stage/CollectibleContainer
@onready var round_sequencer: Node2D = $Stage/RoundSequencer
@onready var background_container: Node2D = $Stage/BackgroundContainer
@onready var hud: Control = $HUD
@onready var player: Player = $Stage/Player

signal finished

func _ready() -> void:
	Globals.score = 0 #only for first level
	SignalBus.player_health_changed.connect(_on_player_health_changed)
	Globals.bullet_container = bullet_container
	Globals.enemy_container = enemy_container
	Globals.collectible_container = collectible_container
	Globals.background_container = background_container
	Globals.stage_position = stage.position
	start_game()
	black_fade_transition.transition_to_transparent()

func start_game():
	Globals.player_health = Globals.max_player_health
	player.is_active = true
	hud.update_life_heart_count(Globals.player_health)
	round_sequencer.begin()

func _on_player_health_changed(new_player_health) -> void:
	if new_player_health < 0:
		get_tree().call_deferred("reload_current_scene")
	hud.update_life_heart_count(new_player_health)

func _on_round_sequencer_finished() -> void:
	queue_free()
	finished.emit()
