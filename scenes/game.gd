extends Node

@onready var bullet_container: Node2D = $Stage/BulletContainer

func _ready() -> void:
	GameProperties.bullet_container = bullet_container
