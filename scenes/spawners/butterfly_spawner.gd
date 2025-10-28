extends Marker2D

const BUTTERFLY = preload("uid://d4l2pjdrcg7w5")

func begin() -> void:
	var butterfly = BUTTERFLY.instantiate()
	butterfly.position = position
	Globals.enemy_container.add_child(butterfly)
	butterfly.tree_exited.connect(queue_free)
