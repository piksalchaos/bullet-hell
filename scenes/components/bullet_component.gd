class_name BulletComponent extends Area2D

@export var offscreen_distance: float = 1.0
@onready var parent: Node2D = get_parent()

const CAPTURE_SHRINK_DURATION = 0.1

func _physics_process(_delta: float) -> void:
	if parent.position.x < -offscreen_distance \
	or parent.position.x > Globals.STAGE_WIDTH + offscreen_distance \
	or position.y < -offscreen_distance \
	or position.y > Globals.STAGE_HEIGHT + offscreen_distance:
		parent.queue_free()

func _on_area_entered(area: Player) -> void:
	if not area.is_on_cooldown:
		parent.queue_free()
		area.hit()

func capture_color_id() -> int:
	var color_component = parent.color_component
	if not color_component.disabled:
		return color_component.color_id
	return -1

func disable_color():
	parent.color_component.disable()
