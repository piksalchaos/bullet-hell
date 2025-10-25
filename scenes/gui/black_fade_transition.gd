extends ColorRect

@export var is_transparent = true:
	set = set_is_transparent
@export var tween_duration = 0.75

signal finished_transition()

func set_is_transparent(value):
	is_transparent = value
	color.a = 0 if is_transparent else 1

func transition_to_black():
	transition(Color.BLACK, func():
		is_transparent = false
		finished_transition.emit()
	)

func transition_to_transparent():
	transition(Color(Color.BLACK, 0), func():
		is_transparent = true
		finished_transition.emit()
	)

func transition(new_color: Color, callback: Callable):
	var tween = create_tween()
	tween.tween_property(self, "color", new_color, tween_duration)
	tween.tween_callback(callback)
