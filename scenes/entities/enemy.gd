extends Node2D

const BASE_BULLET = preload("res://scenes/bullets/base_bullet.tscn")

func _on_bullet_timer_timeout() -> void:
	var bullet = BASE_BULLET.instantiate()
	bullet.position = position
	bullet.rotation = (GameProperties.player_position - position).angle()
	GameProperties.bullet_container.add_child(bullet)
