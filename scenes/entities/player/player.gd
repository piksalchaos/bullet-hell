class_name Player extends Area2D

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var sprite_2d: Sprite2D = $Sprite2D

const PLAYER_BULLET = preload("res://scenes/bullets/player_bullet.tscn")
const WIDTH := 16.0
const SPEED := 240.0
const SLOW_SPEED := 120.0
const COOLDOWN_ALPHA = 0.3

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

func hit() -> void:
	got_hit.emit()
	sprite_2d.modulate.a = COOLDOWN_ALPHA
	is_on_cooldown = true
	cooldown_timer.start()

func _on_cooldown_timer_timeout() -> void:
	is_on_cooldown = false
	sprite_2d.modulate.a = 1
