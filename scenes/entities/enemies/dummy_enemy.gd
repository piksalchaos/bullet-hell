extends Node2D

const GHOST_BULLET = preload("res://scenes/bullets/ghost_bullet.tscn")
const TWEEN_ENTER_DURATION := 0.75
const TWEEN_EXIT_DURATION := 1.5
@onready var bullet_timer: Timer = $BulletTimer
@onready var color_component: ColorComponent = $ColorComponent

@export var starting_position: Vector2
@export var initial_color_id: Globals.COLOR_ID

func _ready() -> void:
	change_position(starting_position, begin_attacking, TWEEN_ENTER_DURATION)
	color_component.color_id = initial_color_id

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
	print('wa')
	var bullet = GHOST_BULLET.instantiate()
	bullet.position = position
	bullet.rotation = (Globals.player_position - position).angle()
	bullet.initial_color_id = initial_color_id
	Globals.bullet_container.add_child(bullet)
