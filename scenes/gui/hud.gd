extends Control

const LIFE_HEART = preload("uid://cg285sbaifnvs")
const NUMBER_OF_DIGITS_ON_LABEL := 8

@onready var life_heart_container: HBoxContainer = $RightBar/LifeHeartContainer
@onready var score_label: Label = $RightBar/ScoreLabel

func _ready() -> void:
	SignalBus.score_updated.connect(_on_score_updated)
	update_score_label(Globals.score)

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
	var number_of_digits = 0 if new_score == 0 else str(new_score).length()
	if number_of_digits == 0:
		score_label.text = "0".repeat(NUMBER_OF_DIGITS_ON_LABEL)
	elif number_of_digits < NUMBER_OF_DIGITS_ON_LABEL:
		score_label.text = "0".repeat(NUMBER_OF_DIGITS_ON_LABEL - number_of_digits) + str(new_score)
	else:
		score_label.text = str(new_score)
