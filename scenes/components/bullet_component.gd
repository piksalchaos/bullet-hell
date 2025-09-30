class_name BulletComponent extends Area2D

@export var offscreen_distance: float = 1.0
@onready var parent: Node2D = get_parent()

const CAPTURE_SHRINK_DURATION = 0.1

func _physics_process(_delta: float) -> void:
	if parent.position.x < -offscreen_distance \
	or parent.position.x > GameProperties.STAGE_WIDTH + offscreen_distance \
	or position.y < -offscreen_distance \
	or position.y > GameProperties.STAGE_HEIGHT + offscreen_distance:
		parent.queue_free()

func _on_area_entered(area: Player) -> void:
	if not area.is_on_cooldown:
		parent.queue_free()
		area.hit()

func capture_color():
	GameProperties.captured_color_ids.append(parent.color_component.color_id)
	var tween = get_tree().create_tween()
	tween.tween_property(parent, "scale", Vector2.ZERO, CAPTURE_SHRINK_DURATION)
	tween.tween_callback(capture_tween_callback)

func capture_tween_callback():
	SignalBus.bullet_captured.emit(parent.position, parent.color_component.color_id)
	parent.queue_free()
	
