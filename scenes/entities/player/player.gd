class_name Player extends Area2D

@export var is_vulnerable := true

@onready var bullet_absorber: Area2D = $BulletAbsorber
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var main_sprite: AnimatedSprite2D = $MainSprite
@onready var shadow_sprite: AnimatedSprite2D = $ShadowSprite
@onready var heart_sprite: Sprite2D = $HeartSprite
@onready var hit_audio: AudioStreamPlayer = $HitAudio
@onready var hit_cooldown_audio: AudioStreamPlayer = $HitCooldownAudio
@onready var recover_audio: AudioStreamPlayer = $RecoverAudio
@onready var hit_particles: CPUParticles2D = $HitParticles

const PLAYER_BULLET = preload("res://scenes/bullets/player_bullet.tscn")
const WIDTH := 12.0
const SPEED := 240.0
const SLOW_SPEED := 120.0

var is_active = false
var is_on_cooldown = false

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
		main_sprite.position.x = (randf()-0.5) * cooldown_timer.time_left * 16
		heart_sprite.position.x = (randf()-0.5) * cooldown_timer.time_left * 5
		heart_sprite.position.y = (randf()-0.5) * cooldown_timer.time_left * 5
		

func hit() -> void:
	if is_vulnerable:
		Globals.player_health -= 1
	main_sprite.modulate.a = 0.4
	shadow_sprite.self_modulate.a = 0.15
	heart_sprite.modulate.a = 0.12
	is_on_cooldown = true
	cooldown_timer.start()
	hit_audio.play()
	hit_cooldown_audio.play()
	var tween = create_tween()
	tween.tween_property(bullet_absorber, "scale", Vector2(0.1, 0.1), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	#bullet_absorber.modulate = Color(Color.WHITE, 0.8)
	bullet_absorber.monitoring = false
	hit_particles.emitting = true

func _on_cooldown_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(bullet_absorber, "scale", Vector2(0.8, 0.8), 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	tween.tween_callback(reset_after_hit)

func reset_after_hit():
	is_on_cooldown = false
	bullet_absorber.show()
	main_sprite.modulate.a = 1
	shadow_sprite.self_modulate.a = 0.6
	heart_sprite.modulate.a = 1
	main_sprite.position.x = 0
	heart_sprite.position.x = 0
	bullet_absorber.monitoring = true
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(bullet_absorber, "scale", Vector2(1, 1), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(bullet_absorber, "modulate", Color.WHITE, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	hit_cooldown_audio.stop()
	recover_audio.play()
