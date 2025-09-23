class_name Enemy extends Node2D

const BASE_BULLET = preload("res://scenes/bullets/base_bullet.tscn")
@onready var bullet_timer: Timer = $BulletTimer

@export var starting_position: Vector2

func _ready() -> void:
	change_position(starting_position)

func change_position(new_position: Vector2) -> void:
	bullet_timer.stop()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_position, 0.5) \
	 	 .set_ease(Tween.EASE_OUT) \
		 .set_trans(Tween.TRANS_SINE)
	tween.tween_callback(begin_attacking)

	
func begin_attacking() -> void:
	bullet_timer.start()

func _on_bullet_timer_timeout() -> void:
	var bullet = BASE_BULLET.instantiate()
	bullet.position = position
	bullet.rotation = (GameProperties.player_position - position).angle()
	GameProperties.bullet_container.add_child(bullet)
