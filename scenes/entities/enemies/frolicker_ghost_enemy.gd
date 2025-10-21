extends Node2D

const TWEEN_ENTER_DURATION := 0.75
const TWEEN_EXIT_DURATION := 1.5

@export var color_component: ColorComponent
@export var pattern_root: Node2D
@export var pattern_root_2: Node2D
@export var bullet_emitter: BulletEmitter

@export var starting_position: Vector2
@export var ending_position: Vector2
@export var transition_time: float = 3.0
@export var initial_color_id: Globals.COLOR_ID

func _ready() -> void:
	change_position(starting_position, begin_attacking, TWEEN_ENTER_DURATION)
	color_component.set_color_id(initial_color_id)

func change_position(
	new_position: Vector2,
	callback: Callable = func(): pass,
	tween_duration: float = TWEEN_ENTER_DURATION,
	ease_type: Tween.EaseType = Tween.EASE_OUT,
	transition_type:  Tween.TransitionType = Tween.TRANS_SINE
) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_position, tween_duration) \
	 	 .set_ease(ease_type) \
		 .set_trans(transition_type)
	tween.tween_callback(callback)
	
func begin_attacking() -> void:
	pattern_root.begin()
	pattern_root_2.begin()
	goto_end_position()

func goto_end_position():
	change_position(ending_position, goto_start_position, transition_time, Tween.EASE_IN_OUT)

func goto_start_position():
	change_position(starting_position, goto_end_position, transition_time, Tween.EASE_IN_OUT)
