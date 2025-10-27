extends Node2D

const POSITION_RANGE := Rect2(60, 60, Globals.STAGE_WIDTH-120, Globals.STAGE_HEIGHT*0.3 - 120)
const STAGE_TWO_POSITION = Vector2(Globals.STAGE_WIDTH*0.5, 200)
const DEFAULT_TWEEN_ENTER_DURATION := 0.75
const TWEEN_EXIT_DURATION := 1.5

@export var color_component: ColorComponent

@export var starting_position: Vector2
@export var initial_color_id: Globals.COLOR_ID
@export var tween_enter_duration := DEFAULT_TWEEN_ENTER_DURATION

@onready var reposition_timer: Timer = $RepositionTimer
@onready var stage_transition_timer: Timer = $StageTransitionTimer
@onready var health_component_container: Node2D = $HealthComponentContainer
@onready var pattern_emitter_container: Node2D = $PatternEmitterContainer
@onready var hitbox_component: HitboxComponent = $HitboxComponent

var current_health_component: HealthComponent
var current_pattern_emitter

func _ready() -> void:
	change_position(starting_position, next_stage, tween_enter_duration)
	color_component.set_color_id(initial_color_id)

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
	
func next_stage() -> void:
	if health_component_container.get_child_count() == 0:
		queue_free()
		return
	current_health_component = health_component_container.get_child(0)
	current_health_component.show()
	hitbox_component.health_component = current_health_component
	current_health_component.defeated.connect(_on_health_component_defeated)
	
	current_pattern_emitter = pattern_emitter_container.get_child(0)
	current_pattern_emitter.begin()
	
	if current_pattern_emitter.name == "PatternEmitter2":
		change_position(STAGE_TWO_POSITION)
		reposition_timer.stop()
	else:
		change_position_and_repeat()

func _on_health_component_defeated():
	current_health_component.queue_free()
	current_pattern_emitter.queue_free()
	reposition_timer.stop()
	stage_transition_timer.start()

func _on_reposition_timer_timeout() -> void:
	change_position_and_repeat()

func change_position_and_repeat():
	var new_position = POSITION_RANGE.position + POSITION_RANGE.size*Vector2(randf(), randf())
	change_position(new_position, reposition_timer.start)

func _on_stage_transition_timer_timeout() -> void:
	next_stage()
