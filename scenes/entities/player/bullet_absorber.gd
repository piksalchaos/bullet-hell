extends Area2D

const PLAYER_BULLET = preload("res://scenes/bullets/player_bullet.tscn")
var color_absorption: Dictionary = {}
var selected_color_id := 0
@onready var bullet_timer: Timer = $BulletTimer

func _draw() -> void:
	draw_circle(Vector2.ZERO, 32, Color.WHITE, false, 2)

func _on_area_entered(bullet: Area2D) -> void:
	var color_id = bullet.capture_color_id()
	if not color_id: return
	if color_absorption.has(color_id):
		color_absorption[color_id] += 1
	else:
		color_absorption[color_id] = 1
		if not color_absorption.has(selected_color_id):
			selected_color_id = color_id
	print(color_absorption)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("switch_right"):
		switch_color(true)
	if event.is_action_pressed("switch_left"):
		switch_color(false)
	if event.is_action_pressed("shoot"):
		shoot_bullet()
		bullet_timer.start()
	if event.is_action_released("shoot"):
		bullet_timer.stop()

func switch_color(is_right: bool = true) -> void:
	if color_absorption.size() <= 0: return
	var color_id_count = GameProperties.COLOR_ID.size()
	var id_offset = 1 if is_right else - 1
	var color_id_to_check = (selected_color_id + id_offset + color_id_count) % color_id_count
	while not color_absorption.has(color_id_to_check):
		color_id_to_check = (color_id_to_check + id_offset + color_id_count) % color_id_count
	selected_color_id = color_id_to_check

func shoot_bullet():
	if not color_absorption.has(selected_color_id): return
	var bullet = PLAYER_BULLET.instantiate()
	bullet.initial_color_id = selected_color_id
	bullet.position = get_parent().position
	GameProperties.bullet_container.add_child(bullet)
	color_absorption[selected_color_id] -= 1
	if color_absorption[selected_color_id] <= 0:
		color_absorption.erase(selected_color_id)
		switch_color()

func _on_bullet_timer_timeout() -> void:
	shoot_bullet()
