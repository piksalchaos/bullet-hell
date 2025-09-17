extends Area2D

const RADIUS := 6.0
const SPEED := 400.0

func _process(delta: float) -> void:
	position.y -= SPEED * delta
	if position.x < -RADIUS or position.x > GameProperties.STAGE_WIDTH + RADIUS \
	or position.y < -RADIUS or position.y > GameProperties.STAGE_HEIGHT + RADIUS:
		queue_free()
