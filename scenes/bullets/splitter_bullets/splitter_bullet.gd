extends Node2D

const SPLITTER_BULLET = preload("uid://dk2726nirtct0")
const SPLITTER_BULLET_FINAL = preload("uid://bdhseghbd6ixv")

const INITIAL_DISTANCE := 80.0
const TWEEN_DURATION := 1.5
const MAX_STAGE := 4
@export var initial_color_id: Globals.COLOR_ID
@export var stage := 0
@onready var color_component: ColorComponent = $ColorComponent
@onready var pattern_randomizer: Node2D = $PatternRandomizer

func _ready() -> void:
	color_component.set_color_id(initial_color_id)
	scale = Vector2(1, 1) * (1.0 - stage*0.1)
	
	var next_position = position + Vector2(cos(rotation), sin(rotation)) * INITIAL_DISTANCE
	var tween = create_tween()
	tween.tween_property(self, "position", next_position, TWEEN_DURATION) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(begin_split)
	
	modulate = Color.TRANSPARENT
	var modulate_tween = create_tween()
	modulate_tween.tween_property(self, "modulate", Color.WHITE, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func begin_split():
	var tween = create_tween()
	tween.tween_property(self, "scale", scale * 1.2, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_callback(split)
	tween.tween_property(self, "scale", scale * 1.4, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate", Color.TRANSPARENT, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_callback(queue_free)

func split():
	var next_stage = stage + 1
	var split_amount = 3 if next_stage < 3 else 2
	if next_stage < MAX_STAGE:
		for i in split_amount:
			var bullet = SPLITTER_BULLET.instantiate()
			bullet.position = Globals.get_position_relative_to_stage(global_position)
			bullet.rotation = randf() * 2 * PI
			bullet.initial_color_id = Globals.COLOR_ID.WHITE
			bullet.stage = stage + 1
			Globals.bullet_container.add_child(bullet)
	else:
		pattern_randomizer.begin()
