extends PathFollow2D

@onready var color_component: ColorComponent = $ColorComponent
@onready var bullet_emitter: Node2D = $BulletEmitter
@onready var pattern_repeater: Node2D = $PatternRepeater

@export var initial_color_id: Globals.COLOR_ID
@export var speed: float = 120

func _ready() -> void:
	color_component.color_id = initial_color_id
	bullet_emitter.color_id = initial_color_id

func _process(delta: float) -> void:
	progress += speed * delta
	if progress_ratio >= 1:
		queue_free()

func shoot():
	bullet_emitter.begin()
