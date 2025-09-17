extends Area2D

const RADIUS := 16.0

const SPEED := 240.0
const SLOW_SPEED := 180.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var x_direction = Input.get_axis("left", "right")
	var y_direction = Input.get_axis("up", "down")
	var direction = Vector2(x_direction, y_direction).normalized()
	var velocity = direction * (SLOW_SPEED if Input.is_action_pressed("slow") else SPEED) * delta
	position += velocity
	
	position.x = clampf(position.x, RADIUS, GameProperties.STAGE_WIDTH - RADIUS)
	print(GameProperties.STAGE_WIDTH, "  ", position.x)
	position.y = clampf(position.y, RADIUS, GameProperties.STAGE_HEIGHT - RADIUS)
