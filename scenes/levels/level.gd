class_name Level extends Node

@export var is_first_level := false

@onready var black_fade_transition: ColorRect = $BlackFadeTransition
@onready var stage: Node2D = $Stage
@onready var bullet_container: Node2D = $Stage/BulletContainer
@onready var enemy_container: Node2D = $Stage/EnemyContainer
@onready var collectible_container: Node2D = $Stage/CollectibleContainer
@onready var round_sequencer: Node2D = $Stage/RoundSequencer
@onready var background_container: Node2D = $Stage/BackgroundContainer
@onready var hud: Control = $HUD
@onready var player: Player = $Stage/Player
@onready var music_audio: AudioStreamPlayer = $MusicAudio

var is_playing := false
var play_time := 0.0

signal finished

func _ready() -> void:
	if is_first_level:
		Globals.score = 0
	
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
	is_playing = true

func _on_player_health_changed(new_player_health) -> void:
	if new_player_health < 0:
		get_tree().call_deferred("reload_current_scene")
	hud.update_life_heart_count(new_player_health)

func _on_round_sequencer_finished() -> void:
	is_playing = false
	var play_time_bonus = maxi(0, (390 - floori(play_time)) * 3)
	Globals.score += play_time_bonus
	hud.show_stage_clear_screen(floori(play_time), play_time_bonus)
	var tween = create_tween()
	tween.tween_property(music_audio, "volume_db", -50, 2.5)
	tween.tween_callback(func():
		music_audio.stop()
	)

func _process(delta: float) -> void:
	if is_playing:
		play_time += delta
