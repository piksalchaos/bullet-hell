extends Area2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("absorb") and GameProperties.captured_color_ids.size() < 6:
		capture_closest_bullet()

func capture_closest_bullet():
	var closest_distance = INF
	var closest_bullet_component: BulletComponent
	for bullet_component in get_overlapping_areas():
		var distance = position.distance_squared_to(bullet_component.position)
		if distance < closest_distance:
			closest_distance = distance
			closest_bullet_component = bullet_component
	if closest_bullet_component:
		closest_bullet_component.capture_color()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 15, Color.WHITE, false, 2)
