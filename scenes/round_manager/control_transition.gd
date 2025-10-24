extends Control

@export var node_to_free_with: Node

func _ready() -> void:
	node_to_free_with.tree_exited.connect(begin_tween_out)

func begin() -> void:
	show()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)

func begin_tween_out() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	tween.tween_callback(queue_free)
