extends Node2D

const TWEEN_ENTER_DURATION := 0.75
const TWEEN_EXIT_DURATION := 1.5
@onready var exit_timer: Timer = $ExitTimer
@onready var color_component: ColorComponent = $ColorComponent
@onready var bullet_emitter: Node2D = $PatternRepeater/PatternAimer/PatternSpreader/BulletEmitter
@onready var pattern_repeater: Node2D = $PatternRepeater

@export var starting_position: Vector2
@export var initial_color_id: Globals.COLOR_ID
@export var exit_time: float = 8

func _ready() -> void:
	change_position(starting_position, begin_attacking, TWEEN_ENTER_DURATION)
	color_component.color_id = initial_color_id
	bullet_emitter.color_id = initial_color_id
	exit_timer.wait_time = exit_time
	exit_timer.start()

func change_position(
	new_position: Vector2,
	callback: Callable = func(): pass,
	tween_duration: float = TWEEN_ENTER_DURATION,
	ease_type: Tween.EaseType = Tween.EASE_OUT
) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_position, tween_duration) \
	 	 .set_ease(ease_type) \
		 .set_trans(Tween.TRANS_SINE)
	tween.tween_callback(callback)
	
func begin_attacking() -> void:
	pattern_repeater.begin()
	
func _on_exit_timer_timeout() -> void:
	var new_position = Vector2(
		-100 if Globals.STAGE_WIDTH - position.x > Globals.STAGE_WIDTH*0.5 else Globals.STAGE_WIDTH + 100,
		position.y + 40
	)
	change_position(new_position, func(): queue_free(), TWEEN_EXIT_DURATION, Tween.EASE_IN)
