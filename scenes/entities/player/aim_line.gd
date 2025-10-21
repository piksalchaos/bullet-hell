extends Node2D

const DASH_DISTANCE := 45.0
const MAX_DASH_LENGTH := 15.0
const MAX_Y_OFFSET_SPEED := 360.0
const MIN_Y_OFFSET_SPEED := 60.0
const CROSSHAIR_DISTANCE := 5.0
const CROSSHAIR_LENGTH := 7.5
const TWEEN_IN_DURATION := 0.5
const TWEEN_OUT_DURATION := 0.2

var y_offset := 0.0
var y_offset_speed = MIN_Y_OFFSET_SPEED
var length_factor := 0.0
var tween
@onready var ray_cast: RayCast2D = $RayCast

func _draw() -> void:
	var line_length = global_position.y
	if ray_cast.is_colliding():
		line_length -= ray_cast.get_collision_point().y
	for i in line_length/DASH_DISTANCE:
		var y_position_1 = maxf(-DASH_DISTANCE * i + y_offset, -line_length)
		var y_position_2 = maxf(y_position_1 - (MAX_DASH_LENGTH * length_factor), -line_length)
		draw_line(Vector2(0, y_position_1), Vector2(0, y_position_2), Color.WHITE, -1, true)
	#draw_circle(Vector2(0, -line_length), 16, Color.WHITE, false, 1, true)
	for i in 4:
		var angle = PI/4 + i*PI/2 + PI*length_factor
		var unit_vector = Vector2(cos(angle), sin(angle))
		var center_position = Vector2(0, -line_length)
		draw_line(
			center_position + unit_vector*CROSSHAIR_DISTANCE*length_factor,
			center_position+ unit_vector*(CROSSHAIR_DISTANCE + CROSSHAIR_LENGTH)*length_factor,
			Color.WHITE, -1, true
		)

func _process(delta: float) -> void:
	if not visible: return
	y_offset -= y_offset_speed * delta
	if y_offset <= -DASH_DISTANCE:
		y_offset += DASH_DISTANCE
	queue_redraw()

func show_with_transition():
	show()
	y_offset_speed = MAX_Y_OFFSET_SPEED
	length_factor = 0
	if tween is Tween and tween.is_valid():
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(self, "y_offset_speed", MIN_Y_OFFSET_SPEED, TWEEN_IN_DURATION)
	tween.tween_property(self, "length_factor", 1.0, TWEEN_IN_DURATION).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)

func hide_with_transition():
	hide()
	#var tween_1 = get_tree().create_tween()
	#var tween_2 = get_tree().create_tween()
	#tween_1.tween_property(self, "y_offset_speed", MAX_Y_OFFSET_SPEED, TWEEN_OUT_DURATION)
	#tween_2.tween_property(self, "length_factor", 0.0, TWEEN_OUT_DURATION).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	#tween_2.tween_callback(hide)
