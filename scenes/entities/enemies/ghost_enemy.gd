extends Node2D

const GHOST_BULLET = preload("res://scenes/bullets/ghost_bullet.tscn")
const TWEEN_ENTER_DURATION := 0.75
const TWEEN_EXIT_DURATION := 1.5
@onready var bullet_timer: Timer = $BulletTimer
@onready var exit_timer: Timer = $ExitTimer
@onready var color_component: ColorComponent = $ColorComponent

@export var starting_position: Vector2
@export var initial_color_id: GameProperties.COLOR_ID
@export var exit_time: float = 8

func _ready() -> void:
	change_position(starting_position, begin_attacking, TWEEN_ENTER_DURATION)
	color_component.color_id = initial_color_id
	exit_timer.wait_time = exit_time
	exit_timer.start()

func change_position(
	new_position: Vector2,
	callback: Callable = func(): pass,
	tween_duration: float = TWEEN_ENTER_DURATION,
	ease_type: Tween.EaseType = Tween.EASE_OUT
) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_position, tween_duration) \
	 	 .set_ease(ease_type) \
		 .set_trans(Tween.TRANS_SINE)
	tween.tween_callback(callback)
	
func begin_attacking() -> void:
	shoot()
	bullet_timer.start()

func _on_bullet_timer_timeout() -> void:
	shoot()

func shoot() -> void:
	var white_bullet_index = randi_range(0, 2)
	for i in 3:
		var bullet = GHOST_BULLET.instantiate()
		bullet.position = position
		bullet.rotation = (GameProperties.player_position - position).angle() + PI*0.15*(i - 1)
		bullet.initial_color_id = GameProperties.COLOR_ID.WHITE if white_bullet_index == i else GameProperties.COLOR_ID.RED
		GameProperties.bullet_container.add_child(bullet)

func _on_exit_timer_timeout() -> void:
	var new_position = Vector2(
		-100 if GameProperties.STAGE_WIDTH - position.x > GameProperties.STAGE_WIDTH*0.5 else GameProperties.STAGE_WIDTH + 100,
		position.y + 40
	)
	change_position(new_position, func(): queue_free(), TWEEN_EXIT_DURATION, Tween.EASE_IN)
