class_name Player extends Area2D

@export var is_vulnerable := true

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var main_sprite: AnimatedSprite2D = $MainSprite
@onready var shadow_sprite: AnimatedSprite2D = $ShadowSprite
@onready var hit_audio: AudioStreamPlayer = $HitAudio

const PLAYER_BULLET = preload("res://scenes/bullets/player_bullet.tscn")
const WIDTH := 16.0
const SPEED := 240.0
const SLOW_SPEED := 120.0

var is_active = false
var is_on_cooldown = false

signal got_hit()

func _physics_process(delta: float) -> void:
	if not is_active: return
	var x_direction = Input.get_axis("left", "right")
	var y_direction = Input.get_axis("up", "down")
	var direction = Vector2(x_direction, y_direction).normalized()
	var velocity = direction * (SLOW_SPEED if Input.is_action_pressed("slow") else SPEED) * delta
	position += velocity
	
	position.x = clampf(position.x, WIDTH, Globals.STAGE_WIDTH - WIDTH)
	position.y = clampf(position.y, WIDTH, Globals.STAGE_HEIGHT - WIDTH)
	Globals.update_player_position(position)
	update_animation(velocity.x)

func update_animation(velocity_x):
	var animation_name = "default"
	if velocity_x > 0:
		animation_name = "move_right"
	elif velocity_x < 0:
		animation_name = "move_left"
	main_sprite.play(animation_name)
	shadow_sprite.play("hit" if is_on_cooldown else animation_name)
	if is_on_cooldown:
		main_sprite.position.x = (randf()-0.5) * cooldown_timer.time_left * 10

func hit() -> void:
	if is_vulnerable:
		got_hit.emit()
	main_sprite.modulate.a = 0.6
	shadow_sprite.self_modulate.a = 0.2
	is_on_cooldown = true
	cooldown_timer.start()
	hit_audio.play()

func _on_cooldown_timer_timeout() -> void:
	is_on_cooldown = false
	main_sprite.modulate.a = 1
	shadow_sprite.self_modulate.a = 0.6
	main_sprite.position.x = 0
