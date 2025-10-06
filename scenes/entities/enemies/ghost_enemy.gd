extends Node2D

const GHOST_BULLET = preload("res://scenes/bullets/ghost_bullet.tscn")
const TWEEN_DURATION := 0.75
@onready var bullet_timer: Timer = $BulletTimer
@onready var color_component: ColorComponent = $ColorComponent

@export var starting_position: Vector2
@export var initial_color_id: GameProperties.COLOR_ID

func _ready() -> void:
	change_position(starting_position)
	color_component.color_id = initial_color_id

func change_position(new_position: Vector2) -> void:
	bullet_timer.stop()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_position, TWEEN_DURATION) \
	 	 .set_ease(Tween.EASE_OUT) \
		 .set_trans(Tween.TRANS_SINE)
	tween.tween_callback(begin_attacking)

	
func begin_attacking() -> void:
	bullet_timer.start()

func _on_bullet_timer_timeout() -> void:
	for i in 3:
		var bullet = GHOST_BULLET.instantiate()
		bullet.position = position
		bullet.rotation = (GameProperties.player_position - position).angle() + PI*0.1*(i - 1)
		GameProperties.bullet_container.add_child(bullet)
