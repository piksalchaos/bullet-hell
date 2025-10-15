extends Node2D

const INITIAL_DISTANCE := 175.0
const TWEEN_DURATION := 0.5
const ACCELERATION = 800.0
@export var initial_color_id: Globals.COLOR_ID
@onready var color_component: ColorComponent = $ColorComponent

var direction: Vector2
var speed := 0.0
var is_chasing_player = false

func _ready() -> void:
	color_component.set_color_id(initial_color_id)
	
	var next_position = position + Vector2(cos(rotation), sin(rotation)) * INITIAL_DISTANCE
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", next_position, TWEEN_DURATION) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(chase_player)



func chase_player():
	is_chasing_player = true
	direction = (Globals.player_position - position).normalized()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation", direction.angle() + 2*PI, 0.75) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
func _physics_process(delta: float) -> void:
	if is_chasing_player:
		speed += ACCELERATION * delta #i think there's a way to make this more accurate w calculus, but dont worry abt it for now
		position += direction * speed * delta
