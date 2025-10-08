extends Area2D

const PLAYER_BULLET = preload("res://scenes/bullets/player_bullet.tscn")
const MAX_COLOR_AMOUNT = 20
var color_amounts: Dictionary = {
	Globals.COLOR_ID.RED: 0,
	Globals.COLOR_ID.YELLOW: 0,
	Globals.COLOR_ID.BLUE: 0
}
var selected_color_id := 0
@onready var bullet_timer: Timer = $BulletTimer

func _draw() -> void:
	draw_circle(Vector2.ZERO, 45, Color.WHITE, false, 2)

func _on_area_entered(bullet: Area2D) -> void:
	var color_id = bullet.capture_color_id()
	var color_amounts_empty_before = true
	for color_amount in color_amounts.values():
		if color_amount > 0: color_amounts_empty_before = false
	var color_ids_used = add_color_id_to_color_amounts(color_id)
	if not color_ids_used.is_empty():
		if color_amounts_empty_before:
			SignalBus.selected_color_changed.emit(color_ids_used[0])
	bullet.disable_color()

func add_color_id_to_color_amounts(color_id: Globals.COLOR_ID) -> Array[Globals.COLOR_ID]:
	var color_ids_used: Array[Globals.COLOR_ID] = []
	if Globals.PRIMARY_COLORS.has(color_id):
		if increment_primary_color_amount(color_id): color_ids_used.append(color_id)
	elif Globals.SECONDARY_COLOR_MAP.has(color_id):
		for primary_color_id in Globals.SECONDARY_COLOR_MAP[color_id]:
			if increment_primary_color_amount(primary_color_id): color_ids_used.append(color_id)
	return color_ids_used

func increment_primary_color_amount(color_id: Globals.COLOR_ID) -> bool:
	if not color_amounts.has(color_id) or color_amounts[color_id] >= MAX_COLOR_AMOUNT:
		return false
	color_amounts[color_id] += 1
	SignalBus.color_amount_changed.emit(color_id, float(color_amounts[color_id]) / float(MAX_COLOR_AMOUNT))
	return true

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
	var primary_color_index = Globals.PRIMARY_COLORS.find(selected_color_id)
	var primary_color_count = Globals.PRIMARY_COLORS.size()
	var offset = 1 if is_right else -1
	selected_color_id = Globals.PRIMARY_COLORS[(primary_color_index + offset) % primary_color_count]
	SignalBus.selected_color_changed.emit(selected_color_id)

func shoot_bullet():
	if color_amounts[selected_color_id] <= 0: return
	var bullet = PLAYER_BULLET.instantiate()
	bullet.initial_color_id = selected_color_id
	bullet.position = get_parent().position
	Globals.bullet_container.add_child(bullet)
	color_amounts[selected_color_id] -= 1
	if color_amounts[selected_color_id] <= 0:
		SignalBus.color_amount_changed.emit(selected_color_id, 0)
		return
	SignalBus.color_amount_changed.emit(selected_color_id, float(color_amounts[selected_color_id]) / float(MAX_COLOR_AMOUNT))
	print(selected_color_id)

func _on_bullet_timer_timeout() -> void:
	shoot_bullet()
