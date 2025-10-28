extends Area2D

const PLAYER_BULLET = preload("res://scenes/bullets/player_bullet.tscn")
const SHOT_COLOR_AMOUNT = 3
const HEAL_COLOR_AMOUNT = 1
const MAX_COLOR_AMOUNT = 9
var color_amounts: Array[int] = [0, 0, 0]
var selected_primary_color_index := 0
var mixed_primary_color_index := 0
var found_color_to_mix := false

var is_mixing = false
var is_shot_prepared = false
var is_healing = false
@onready var heal_timer: Timer = $HealTimer
@onready var heal_effect: Node2D = $"../HealEffect"
@onready var aim_line: Node2D = $"../AimLine"

@onready var shoot_audio: AudioStreamPlayer = $ShootAudio
@onready var switch_left_audio: AudioStreamPlayer = $SwitchLeftAudio
@onready var switch_right_audio: AudioStreamPlayer = $SwitchRightAudio
@onready var absorb_audio: AudioStreamPlayer = $AbsorbAudio
@onready var color_max_audio: AudioStreamPlayer = $ColorMaxAudio
@onready var color_upgrade_audio: AudioStreamPlayer = $ColorUpgradeAudio
@onready var prepare_shot_audio: AudioStreamPlayer = $PrepareShotAudio
@onready var release_shot_audio: AudioStreamPlayer = $ReleaseShotAudio
@onready var release_mixed_shot_audio: AudioStreamPlayer = $ReleaseMixedShotAudio
@onready var mix_color_audio: AudioStreamPlayer = $MixColorAudio
@onready var fail_color_action_audio: AudioStreamPlayer = $FailColorActionAudio

func _on_area_entered(bullet_component: Area2D) -> void:
	var color_id = bullet_component.capture_color_id()
	#var color_amounts_empty_before = true
	#for color_amount in color_amounts:
		#if color_amount > 0: color_amounts_empty_before = false
	
	var primary_color_indices_used = add_color_id_to_color_amounts(color_id)
	if not primary_color_indices_used.is_empty():
		absorb_audio.play()
		#if color_amounts_empty_before:
			#selected_primary_color_index = primary_color_indices_used[0]
			#SignalBus.selected_color_changed.emit(selected_primary_color_index)
	bullet_component.color_component.subtract_colors(primary_color_indices_used)

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
	set_color_amount(primary_color_index, color_amounts[primary_color_index] + 1)
	var color_amount = color_amounts[primary_color_index]
	if color_amount == MAX_COLOR_AMOUNT:
		color_max_audio.play()
	elif primary_color_index == selected_primary_color_index \
	and color_amount == SHOT_COLOR_AMOUNT \
	and Input.is_action_pressed("shoot"):
		prepare_shot_audio.play()
	elif color_amount % SHOT_COLOR_AMOUNT == 0:
		color_upgrade_audio.pitch_scale = 1.0 if color_amount == SHOT_COLOR_AMOUNT else 1.1
		color_upgrade_audio.play()
	return true

func _input(event: InputEvent) -> void:
	if not is_healing:
		if is_mixing:
			if event.is_action_pressed("switch_right"):
				mix_color(true)
			if event.is_action_pressed("switch_left"):
				mix_color(false)
		else:
			if event.is_action_pressed("switch_right"):
				switch_color(true)
				switch_left_audio.play()
			if event.is_action_pressed("switch_left"):
				switch_color(false)
				switch_right_audio.play()
		if event.is_action_pressed("shoot"):
			is_shot_prepared = true
			if color_amounts[selected_primary_color_index] >= SHOT_COLOR_AMOUNT:
				prepare_shot_audio.play()
			is_mixing = true
			aim_line.show_with_transition()
			mixed_primary_color_index = selected_primary_color_index
			SignalBus.mixed_colors_changed.emit(mixed_primary_color_index)
		if event.is_action_released("shoot") and is_shot_prepared:
			is_shot_prepared = false
			is_mixing = false
			prepare_shot_audio.stop()
			aim_line.hide_with_transition()
			SignalBus.mixed_colors_changed.emit(-1)
			if found_color_to_mix:
				set_found_color_to_mix(false)
				shoot_mixed_bullet()
			else:
				shoot_bullet()
	
	if event.is_action_pressed("cancel") and is_shot_prepared:
		fail_at_color_action()
		is_shot_prepared = false
		is_mixing = false
		set_found_color_to_mix(false)
		aim_line.hide_with_transition()
		SignalBus.mixed_colors_changed.emit(-1)
	
	if event.is_action_pressed("heal") and not is_shot_prepared:
		prepare_heal()
	if event.is_action_released("heal"):
		end_heal()

func get_adjacent_color_index(is_right: bool = true) -> int:
	var primary_color_count = Globals.PRIMARY_COLORS.size()
	var offset = 1 if is_right else -1
	return (selected_primary_color_index + offset + primary_color_count) % primary_color_count

func switch_color(is_right: bool = true) -> void:
	selected_primary_color_index = get_adjacent_color_index(is_right)
	SignalBus.selected_color_changed.emit(selected_primary_color_index)

func mix_color(is_right: bool = true) -> void:
	var next_primary_color_index = get_adjacent_color_index(is_right)
	if color_amounts[next_primary_color_index] < SHOT_COLOR_AMOUNT \
	or color_amounts[selected_primary_color_index] < SHOT_COLOR_AMOUNT:
		fail_at_color_action()
		return
	switch_color(is_right)
	set_found_color_to_mix(next_primary_color_index != mixed_primary_color_index)
	
	#SignalBus.mixed_colors_changed.emit(selected_primary_color_index, mixed_primary_color_index)
	mix_color_audio.play()

func shoot_bullet():
	var color_amount = color_amounts[selected_primary_color_index]
	if color_amount < SHOT_COLOR_AMOUNT:
		fail_at_color_action()
		return
	if color_amount >= MAX_COLOR_AMOUNT:
		shoot_audio.play()
	release_shot_audio.play()
	var final_color_amount = color_amount % SHOT_COLOR_AMOUNT
	set_color_amount(selected_primary_color_index, final_color_amount)

	var bullet = PLAYER_BULLET.instantiate()
	bullet.initial_color_id = Globals.PRIMARY_COLORS[selected_primary_color_index]
	bullet.position = get_parent().position
	@warning_ignore("integer_division")
	bullet.damage = (color_amount - final_color_amount) / SHOT_COLOR_AMOUNT
	Globals.bullet_container.add_child(bullet)

func shoot_mixed_bullet():
	var amount_subtractor = mini(
		get_color_amount_bullet_subtractor(selected_primary_color_index),
		get_color_amount_bullet_subtractor(mixed_primary_color_index)
	)
	set_color_amount(selected_primary_color_index, color_amounts[selected_primary_color_index] - amount_subtractor)
	set_color_amount(mixed_primary_color_index, color_amounts[mixed_primary_color_index] - amount_subtractor)
	
	release_mixed_shot_audio.play()
	
	var bullet_color_id = get_mixed_secondary_color_id()
	
	var bullet = PLAYER_BULLET.instantiate()
	bullet.initial_color_id = bullet_color_id
	bullet.position = get_parent().position
	bullet.damage = float(amount_subtractor) / SHOT_COLOR_AMOUNT
	Globals.bullet_container.add_child(bullet)

func get_color_amount_bullet_subtractor(primary_color_index):
	@warning_ignore("integer_division")
	return color_amounts[primary_color_index]/SHOT_COLOR_AMOUNT * SHOT_COLOR_AMOUNT

func set_color_amount(primary_color_index: int, new_color_amount: int):
	color_amounts[primary_color_index] = new_color_amount
	SignalBus.color_amount_changed.emit(primary_color_index, float(new_color_amount) / float(MAX_COLOR_AMOUNT))

func set_found_color_to_mix(value):
	found_color_to_mix = value
	SignalBus.found_color_to_mix_changed.emit(value, get_mixed_secondary_color_id())

func fail_at_color_action():
	fail_color_action_audio.play()
	SignalBus.cannot_perform_color_action.emit()


func get_mixed_secondary_color_id() -> Globals.COLOR_ID:
	var bullet_color_id: Globals.COLOR_ID
	for secondary_color_id in Globals.SECONDARY_COLOR_MAP:
		var secondary_color_primary_ids = Globals.SECONDARY_COLOR_MAP[secondary_color_id]
		if secondary_color_primary_ids.has(Globals.PRIMARY_COLORS[selected_primary_color_index]) \
		and secondary_color_primary_ids.has(Globals.PRIMARY_COLORS[mixed_primary_color_index]):
			bullet_color_id = secondary_color_id
			break
	return bullet_color_id

func prepare_heal() -> void:
	var empty_health = Globals.max_player_health - Globals.player_health
	if color_amounts.min() >= HEAL_COLOR_AMOUNT and empty_health >= 1:
		is_healing = true
		heal_timer.start()
		heal_effect.start()
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(0.1, 0.1), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		monitoring = false

func _on_heal_timer_timeout() -> void:
	Globals.player_health += 1
	end_heal()
	heal_effect.emit_success_particles()
	for i in color_amounts.size():
		set_color_amount(i, color_amounts[i] - HEAL_COLOR_AMOUNT)

func end_heal() -> void:
	is_healing = false
	heal_timer.stop()
	heal_effect.stop()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	monitoring = true
