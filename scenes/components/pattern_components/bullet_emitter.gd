class_name BulletEmitter extends Node2D

@export var bullet_scene: PackedScene
@export var color_id: Globals.COLOR_ID

func begin() -> void:
	shoot()

func shoot() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.position = Globals.get_position_relative_to_stage(global_position)
	bullet.rotation = global_rotation
	bullet.initial_color_id = color_id
	Globals.bullet_container.add_child(bullet)
