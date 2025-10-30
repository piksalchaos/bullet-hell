extends Control

const LIFE_HEART = preload("uid://cg285sbaifnvs")
const PROGRESS_ICON = preload("uid://c0f1sgbgv5y71")
const ROUND_TEXTURE = preload("uid://tffba6sdncrd")
const MINIBOSS_ROUND_TEXTURE = preload("uid://cjd336jyoail")
const BOSS_ROUND_TEXTURE = preload("uid://d2afr0j2303sv")

const NUMBER_OF_DIGITS_ON_LABEL := 8
const PROGRESS_ARROW_OFFSET = Vector2(-50, 8)

@onready var life_heart_container: HBoxContainer = $RightBar/LifeHeartContainer
@onready var high_score_label: Label = $RightBar/ScoreDisplay/HBoxContainer/HighScoreLabel
@onready var score_label: Label = $RightBar/ScoreDisplay/HBoxContainer2/ScoreLabel
@onready var stage_clear_screen: PanelContainer = $BattleAreaReference/StageClearScreen
@onready var time_label: Label = $BattleAreaReference/StageClearScreen/MarginContainer/VBoxContainer/TimeDisplay/TimeLabel
@onready var time_bonus_label: Label = $BattleAreaReference/StageClearScreen/MarginContainer/VBoxContainer/TimeBonusDisplay/TimeBonusLabel
@onready var progress_sequence: VBoxContainer = $LeftBar/ProgressSequence
@onready var progress_arrow: TextureRect = $LeftBar/ProgressArrow

var progress_index = -1

func _ready() -> void:
	stage_clear_screen.visible = false
	stage_clear_screen.modulate = Color.TRANSPARENT
	SignalBus.score_updated.connect(_on_score_updated)
	update_score_label(Globals.score)
	SignalBus.progress_indicator_reached.connect(_on_progress_indicator_reached)
	

func update_life_heart_count(new_life_heart_count: int) -> void:
	if new_life_heart_count < 0: return
	#var container_child_count = life_heart_container.get_child_count()
	var life_heart_count = 0
	for life_heart in life_heart_container.get_children():
		if not life_heart.destroyed: life_heart_count += 1
	
	if life_heart_count < new_life_heart_count:
		for i in (new_life_heart_count - life_heart_count):
			var life_heart = LIFE_HEART.instantiate()
			life_heart_container.add_child(life_heart)
	elif life_heart_count > new_life_heart_count:
		for i in (life_heart_count - new_life_heart_count):
			life_heart_container.get_child(life_heart_count - 1 - i).destroy()

func _on_score_updated(new_score: int):
	update_score_label(new_score)

func update_score_label(new_score: int):
	score_label.text = get_score_string(new_score)
	high_score_label.text = get_score_string(Globals.high_score)

func get_score_string(score: int):
	var number_of_digits = 0 if score == 0 else str(score).length()
	if number_of_digits == 0:
		return "0".repeat(NUMBER_OF_DIGITS_ON_LABEL)
	if number_of_digits < NUMBER_OF_DIGITS_ON_LABEL:
		return "0".repeat(NUMBER_OF_DIGITS_ON_LABEL - number_of_digits) + str(score)
	return str(score)

func show_stage_clear_screen(time_seconds: int, time_bonus: int):
	var minutes_shown = floori(time_seconds/60.0)
	var seconds_shown = time_seconds % 60
	if seconds_shown < 10:
		time_label.text = str(minutes_shown) + ":0" + str(seconds_shown)
	else:
		time_label.text = str(minutes_shown) + ":" + str(seconds_shown)
	time_bonus_label.text = str(time_bonus)
	stage_clear_screen.show()
	var tween = create_tween()
	tween.tween_property(stage_clear_screen, "modulate", Color.WHITE, 0.75)

func add_progress_icon(progress_type: ProgressIndicator.PROGRESS_TYPE):
	var progress_icon = PROGRESS_ICON.instantiate()
	match progress_type:
		ProgressIndicator.PROGRESS_TYPE.NORMAL:
			progress_icon.texture = ROUND_TEXTURE
		ProgressIndicator.PROGRESS_TYPE.MINIBOSS:
			progress_icon.texture = MINIBOSS_ROUND_TEXTURE
		ProgressIndicator.PROGRESS_TYPE.BOSS:
			progress_icon.texture = BOSS_ROUND_TEXTURE
	progress_sequence.add_child(progress_icon)
	progress_sequence.move_child(progress_icon, 0)

func _on_progress_indicator_reached():
	progress_index += 1
	print(progress_index)
	var progress_icon_position = progress_sequence.get_child(-1-progress_index).global_position
	if progress_index == 0:
		progress_arrow.visible = true
		progress_arrow.position = Vector2(progress_icon_position.x + PROGRESS_ARROW_OFFSET.x, Globals.STAGE_HEIGHT + 64)
	var tween = create_tween()
	tween.tween_property(progress_arrow, "position", progress_icon_position + PROGRESS_ARROW_OFFSET, 0.5) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
