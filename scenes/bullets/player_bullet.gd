extends Area2D

const RADIUS := 6.0
const SPEED := 1200.0

var damage := 1 

func _physics_process(delta: float) -> void:
	position.y -= SPEED * delta
	if position.x < -RADIUS or position.x > GameProperties.STAGE_WIDTH + RADIUS \
	or position.y < -RADIUS or position.y > GameProperties.STAGE_HEIGHT + RADIUS:
		queue_free()

func _on_area_entered(area: HitboxComponent) -> void:
	queue_free()
	area.hit(damage)
