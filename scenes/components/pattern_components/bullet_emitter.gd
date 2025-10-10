extends Node2D

@export var bullet_scene: PackedScene

func begin() -> void:
	shoot()

func shoot() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.position = Globals.get_position_relative_to_stage(global_position)
	bullet.rotation = global_rotation
	Globals.bullet_container.add_child(bullet)
