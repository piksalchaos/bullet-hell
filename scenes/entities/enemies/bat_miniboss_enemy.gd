extends Node2D

const POSITION_RANGE := Rect2(100, 100, Globals.STAGE_WIDTH-200, Globals.STAGE_HEIGHT*0.4 - 200)
const DEFAULT_TWEEN_ENTER_DURATION := 0.75
const TWEEN_EXIT_DURATION := 1.5

@export var color_component: ColorComponent
@export var pattern_root: Node2D

@export var starting_position: Vector2
@export var initial_color_id: Globals.COLOR_ID
@export var tween_enter_duration := DEFAULT_TWEEN_ENTER_DURATION
@onready var reposition_timer: Timer = $RepositionTimer

func _ready() -> void:
	#change_position(starting_position, begin_attacking, tween_enter_duration)
	color_component.set_color_id(initial_color_id)
	change_position(starting_position, change_position_and_repeat, 4)

func change_position(
	new_position: Vector2,
	callback: Callable = func(): pass,
	tween_duration: float = tween_enter_duration,
	ease_type: Tween.EaseType = Tween.EASE_OUT
) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_position, tween_duration) \
	 	 .set_ease(ease_type) \
		 .set_trans(Tween.TRANS_SINE)
	tween.tween_callback(callback)

func _on_reposition_timer_timeout() -> void:
	change_position_and_repeat()

func change_position_and_repeat():
	var new_position = POSITION_RANGE.position + POSITION_RANGE.size*Vector2(randf(), randf())
	pattern_root.begin()
	change_position(new_position, reposition_timer.start)

func _on_health_component_defeated() -> void:
	Globals.call_deferred("clear_all_bullets")
