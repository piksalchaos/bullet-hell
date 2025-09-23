class_name BulletComponent extends Area2D

@export var offscreen_distance: float = 1.0
@onready var parent: Node2D = get_parent()

func _physics_process(_delta: float) -> void:
	if parent.position.x < -offscreen_distance \
	or parent.position.x > GameProperties.STAGE_WIDTH + offscreen_distance \
	or position.y < -offscreen_distance \
	or position.y > GameProperties.STAGE_HEIGHT + offscreen_distance:
		parent.queue_free()

func _on_area_entered(area: Player) -> void:
	parent.queue_free()

func capture_color():
	GameProperties.captured_color_ids.append(parent.color_component.color_id)
	print(GameProperties.captured_color_ids)
	parent.queue_free()
