extends Area2D

const PLAYER_BULLET = preload("res://scenes/bullets/player_bullet.tscn")
const SHOT_COLOR_AMOUNT = 3
const MAX_COLOR_AMOUNT = 9
var color_amounts := [0, 0, 0]
var selected_primary_color_index := 0
@onready var bullet_timer: Timer = $BulletTimer
@onready var shoot_audio: AudioStreamPlayer = $ShootAudio
@onready var switch_left_audio: AudioStreamPlayer = $SwitchLeftAudio
@onready var switch_right_audio: AudioStreamPlayer = $SwitchRightAudio
@onready var absorb_audio: AudioStreamPlayer = $AbsorbAudio

func _on_area_entered(bullet: Area2D) -> void:
	var color_id = bullet.capture_color_id()
	var color_amounts_empty_before = true
	for color_amount in color_amounts:
		if color_amount > 0: color_amounts_empty_before = false
	
	var primary_color_indices_used = add_color_id_to_color_amounts(color_id)
	if not primary_color_indices_used.is_empty():
		absorb_audio.play()
		if color_amounts_empty_before:
			selected_primary_color_index = primary_color_indices_used[0]
			SignalBus.selected_color_changed.emit(selected_primary_color_index)
	bullet.disable_color()

func add_color_id_to_color_amounts(color_id: Globals.COLOR_ID) -> Array[Globals.COLOR_ID]:
	var primary_color_indices_used: Array[Globals.COLOR_ID] = []
	if Globals.PRIMARY_COLORS.has(color_id):
		var primary_color_index = Globals.PRIMARY_COLORS.find(color_id)
		if increment_primary_color_amount(primary_color_index):
			primary_color_indices_used.append(primary_color_index)
	elif Globals.SECONDARY_COLOR_MAP.has(color_id):
		for primary_color_id in Globals.SECONDARY_COLOR_MAP[color_id]:
			var primary_color_index = Globals.PRIMARY_COLORS.find(primary_color_id)
			if increment_primary_color_amount(primary_color_index):
				primary_color_indices_used.append(primary_color_index)
	return primary_color_indices_used

func increment_primary_color_amount(primary_color_index) -> bool:
	if color_amounts[primary_color_index] >= MAX_COLOR_AMOUNT:
		return false
	color_amounts[primary_color_index] += 1
	SignalBus.color_amount_changed.emit(primary_color_index, float(color_amounts[primary_color_index]) / float(MAX_COLOR_AMOUNT))
	return true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("switch_right"):
		switch_color(true)
		switch_left_audio.play()
	if event.is_action_pressed("switch_left"):
		switch_color(false)
		switch_right_audio.play()
	if event.is_action_pressed("shoot"):
		shoot_bullet()

func switch_color(is_right: bool = true) -> void:
	var primary_color_count = Globals.PRIMARY_COLORS.size()
	var offset = 1 if is_right else -1
	selected_primary_color_index = (selected_primary_color_index + offset) % primary_color_count
	SignalBus.selected_color_changed.emit(selected_primary_color_index)

func shoot_bullet():
	var color_amount = color_amounts[selected_primary_color_index]
	if color_amount < SHOT_COLOR_AMOUNT: return
	shoot_audio.play()
	var final_color_amount = color_amount % SHOT_COLOR_AMOUNT
	SignalBus.color_amount_changed.emit(selected_primary_color_index, float(final_color_amount) / float(MAX_COLOR_AMOUNT))
	color_amounts[selected_primary_color_index] = final_color_amount
	
	var bullet = PLAYER_BULLET.instantiate()
	bullet.initial_color_id = Globals.PRIMARY_COLORS[selected_primary_color_index]
	bullet.position = get_parent().position
	bullet.damage = (color_amount - final_color_amount) / SHOT_COLOR_AMOUNT
	Globals.bullet_container.add_child(bullet)

func _on_bullet_timer_timeout() -> void:
	shoot_bullet()
