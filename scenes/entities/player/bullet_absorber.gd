extends Area2D

const PLAYER_BULLET = preload("res://scenes/bullets/player_bullet.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		if GameProperties.captured_color_ids.size() < 2:
			capture_closest_bullet()
		else:
			shoot_bullet()

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

func shoot_bullet():
	var bullet = PLAYER_BULLET.instantiate()
	bullet.initial_color_id = GameProperties.captured_color_ids[0]
	bullet.position = get_parent().position
	GameProperties.bullet_container.add_child(bullet)
	GameProperties.captured_color_ids = []
