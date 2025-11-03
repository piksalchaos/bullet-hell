extends Control

var destroyed = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func destroy():
	animated_sprite_2d.play("destroy")
	destroyed = true

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
