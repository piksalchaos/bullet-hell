extends Area2D

const PLAYER_BULLET = preload("res://scenes/bullets/player_bullet.tscn")
const MAX_COLOR_AMOUNT = 20
var color_amounts: Dictionary = {}
var selected_color_id := 0
@onready var bullet_timer: Timer = $BulletTimer

func _draw() -> void:
	draw_circle(Vector2.ZERO, 45, Color.WHITE, false, 2)

func _on_area_entered(bullet: Area2D) -> void:
	var color_id = bullet.capture_color_id()
	if color_id < 0 or color_id > 5: return
	if color_amounts.has(color_id):
		if color_amounts[color_id] < MAX_COLOR_AMOUNT:
			color_amounts[color_id] = clampi(color_amounts[color_id] + 1, 0, MAX_COLOR_AMOUNT)
			bullet.disable_color()
	else:
		if not color_amounts.has(selected_color_id):
			selected_color_id = color_id
			SignalBus.selected_color_changed.emit(selected_color_id)
		color_amounts[color_id] = 1
		bullet.disable_color()
	SignalBus.color_amount_changed.emit(color_id, float(color_amounts[color_id]) / float(MAX_COLOR_AMOUNT))

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
	if color_amounts.size() <= 0: return
	var color_id_count = GameProperties.COLOR_ID.size()
	var id_offset = 1 if is_right else -1
	var color_id_to_check = (selected_color_id + id_offset + color_id_count) % color_id_count
	while not color_amounts.has(color_id_to_check):
		color_id_to_check = (color_id_to_check + id_offset + color_id_count) % color_id_count
	selected_color_id = color_id_to_check
	SignalBus.selected_color_changed.emit(selected_color_id)

func shoot_bullet():
	if not color_amounts.has(selected_color_id): return
	var bullet = PLAYER_BULLET.instantiate()
	bullet.initial_color_id = selected_color_id
	bullet.position = get_parent().position
	GameProperties.bullet_container.add_child(bullet)
	color_amounts[selected_color_id] -= 1
	if color_amounts[selected_color_id] <= 0:
		color_amounts.erase(selected_color_id)
		SignalBus.color_amount_changed.emit(selected_color_id, 0)
		switch_color()
		return
	SignalBus.color_amount_changed.emit(selected_color_id, float(color_amounts[selected_color_id]) / float(MAX_COLOR_AMOUNT))

	

func _on_bullet_timer_timeout() -> void:
	shoot_bullet()
