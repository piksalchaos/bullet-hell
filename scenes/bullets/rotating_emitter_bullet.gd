extends Node2D

const INITIAL_VELOCITY := 0.0
const MAX_VELOCITY := 100.0
const ACCELERATION := 100.0

@onready var color_component: ColorComponent = $ColorComponent
@onready var pattern_repeater: Node2D = $PatternRepeater
@onready var bullet_emitter: BulletEmitter = $PatternRepeater/PatternRotator/BulletEmitter
@export var initial_color_id: Globals.COLOR_ID

var velocity := INITIAL_VELOCITY

func _ready() -> void:
	color_component.set_color_id(initial_color_id)
	pattern_repeater.begin()
	bullet_emitter.color_id = initial_color_id

func _physics_process(delta: float) -> void:
	position.y += velocity * delta
	velocity += ACCELERATION * delta
	if velocity > MAX_VELOCITY: velocity = MAX_VELOCITY
