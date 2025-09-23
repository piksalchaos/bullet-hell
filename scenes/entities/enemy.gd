class_name Enemy extends Node2D

const GHOST_BULLET = preload("res://scenes/bullets/ghost_bullet.tscn")
const TWEEN_DURATION := 0.75
@onready var bullet_timer: Timer = $BulletTimer

@export var starting_position: Vector2

func _ready() -> void:
	change_position(starting_position)

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
	var bullet = GHOST_BULLET.instantiate()
	bullet.position = position
	bullet.rotation = (GameProperties.player_position - position).angle()
	GameProperties.bullet_container.add_child(bullet)
