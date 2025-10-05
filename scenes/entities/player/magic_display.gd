extends Node2D
@onready var bullet_absorber: Area2D = $BulletAbsorber
@onready var bullet_shooter: Node2D = $BulletShooter

const ABSORBER_MAX_DISTANCE = 100.0

func _process(_delta: float) -> void:
	var absorber_position = get_local_mouse_position()
	if absorber_position.length() > ABSORBER_MAX_DISTANCE:
		absorber_position = absorber_position.normalized() * ABSORBER_MAX_DISTANCE
	bullet_absorber.position = absorber_position
