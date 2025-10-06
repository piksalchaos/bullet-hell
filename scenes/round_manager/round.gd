class_name Round extends Node2D

func begin() -> void:
	for spawner in get_children():
		spawner.begin()

func _on_child_order_changed() -> void:
	if get_child_count() <= 0:
		queue_free()
