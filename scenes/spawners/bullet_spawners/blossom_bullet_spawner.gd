extends Marker2D

const DANDELION_SEED_BULLET = preload("uid://b0k0cjw3bpgu8")
@export var color_id: Globals.COLOR_ID

func begin() -> void:
	var bullet = DANDELION_SEED_BULLET.instantiate()
	bullet.position = position
	bullet.initial_color_id = color_id
	Globals.bullet_container.add_child(bullet)
	bullet.tree_exited.connect(queue_free)
