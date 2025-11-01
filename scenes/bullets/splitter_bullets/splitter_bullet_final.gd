extends Node2D

const INITIAL_DISTANCE := 60.0
const TWEEN_DURATION := 1.5
const ACCELERATION := 200.0
const MAX_SPEED := 500.0

@export var initial_color_id: Globals.COLOR_ID
@onready var color_component: ColorComponent = $ColorComponent

var is_accelerating := false
var speed := 0.0

func _ready() -> void:
	color_component.set_color_id(initial_color_id)
	
	var next_position = position + Vector2(cos(rotation), sin(rotation)) * INITIAL_DISTANCE
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", next_position, TWEEN_DURATION) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(start_accelerating)

func start_accelerating():
	is_accelerating = true

func _process(delta: float) -> void:
	if is_accelerating:
		speed += ACCELERATION * delta
		if speed > MAX_SPEED: speed = MAX_SPEED
		position += Vector2(cos(rotation), sin(rotation)) * speed * delta
