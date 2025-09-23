class_name Player extends Area2D

const PLAYER_BULLET = preload("res://scenes/bullets/player_bullet.tscn")

const WIDTH := 16.0

const SPEED := 240.0
const SLOW_SPEED := 120.0

@onready var bullet_timer: Timer = $BulletTimer

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		if bullet_timer.is_stopped():
			shoot_bullet()
			bullet_timer.start()
	if event.is_action_released("shoot"):
		bullet_timer.stop()

func _physics_process(delta: float) -> void:
	var x_direction = Input.get_axis("left", "right")
	var y_direction = Input.get_axis("up", "down")
	var direction = Vector2(x_direction, y_direction).normalized()
	var velocity = direction * (SLOW_SPEED if Input.is_action_pressed("slow") else SPEED) * delta
	position += velocity
	
	position.x = clampf(position.x, WIDTH, GameProperties.STAGE_WIDTH - WIDTH)
	position.y = clampf(position.y, WIDTH, GameProperties.STAGE_HEIGHT - WIDTH)
	GameProperties.update_player_position(position)

func shoot_bullet():
	var bullet = PLAYER_BULLET.instantiate()
	bullet.position = position
	GameProperties.bullet_container.add_child(bullet)


func _on_bullet_timer_timeout() -> void:
	shoot_bullet()
