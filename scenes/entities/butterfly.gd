class_name Butterfly extends Area2D

const Y_VELOCITY := 64.0
const X_VELOCITY_ANGLE_SPEED := 1.5
const X_SPEED_FACTOR := 100.0
const HUE_SPEED := 0.15
var x_velocity_angle := 0.0

@onready var sprite: AnimatedSprite2D = $Sprite

func _physics_process(delta: float) -> void:
	position += Vector2(cos(x_velocity_angle) * X_SPEED_FACTOR, Y_VELOCITY) * delta
	x_velocity_angle += X_VELOCITY_ANGLE_SPEED * delta
	sprite.modulate.ok_hsl_h += HUE_SPEED * delta

func destroy():
	set_deferred("monitorable", false)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.4)
	tween.tween_callback(queue_free)
