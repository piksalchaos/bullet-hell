extends Node2D

const BIG_RADIUS_FACTOR := 1.2
const TWEEN_DURATION := 1.5
const SCALE_ANGLE_SPEED := 1.5
const RADIUS_SCALE_AMOUNT = 0.25

const MIN_MAIN_RADIUS := 25.0
const MAX_MAIN_RADIUS := 5.0

const SPEED := 5.0

@onready var circle_drawing: Node2D = $CircleDrawing

var main_radius := 10.0
var scale_radians := 0.0
var direction: Vector2

func _ready():
	main_radius = randf_range(MIN_MAIN_RADIUS, MAX_MAIN_RADIUS)
	scale_radians = 2 * PI * randf()
	circle_drawing.radius = main_radius + main_radius*RADIUS_SCALE_AMOUNT*cos(scale_radians)
	direction = Vector2.DOWN.rotated(randf()-0.5)
	modulate = Color.from_hsv(randf(), 0.3, 1, 0.05)

func _process(delta: float) -> void:
	scale_radians += SCALE_ANGLE_SPEED * delta
	circle_drawing.radius = main_radius + main_radius*RADIUS_SCALE_AMOUNT*cos(scale_radians)
	
	position += direction * (main_radius / MAX_MAIN_RADIUS * SPEED * delta)
