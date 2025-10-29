class_name CollectibleComponent extends Area2D

@export var offscreen_distance: float = 1.0
@export var bounded_by_top: bool = true
@onready var parent: Node2D = get_parent()

signal collected

func _physics_process(_delta: float) -> void:
	if parent.position.x < -offscreen_distance \
	or parent.position.x > Globals.STAGE_WIDTH + offscreen_distance \
	or (bounded_by_top and parent.position.y < -offscreen_distance) \
	or parent.position.y > Globals.STAGE_HEIGHT + offscreen_distance:
		parent.queue_free()

func collect():
	collected.emit()
	set_deferred("monitorable", false)
	var tween = create_tween()
	tween.tween_property(parent, "modulate", Color(Color.BLACK, 0), 0.2)
	tween.tween_callback(queue_free)
