extends Area2D

const SPEED := 200.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var x_direction = Input.get_axis("left", "right")
	var y_direction = Input.get_axis("up", "down")
	var velocity = Vector2(x_direction, y_direction).normalized() * SPEED * delta
	position += velocity
