extends Node

@onready var bullet_container: Node2D = $Stage/BulletContainer
@onready var enemy_container: Node2D = $Stage/EnemyContainer
@onready var round_manager: Node2D = $Stage/RoundManager

func _ready() -> void:
	GameProperties.bullet_container = bullet_container
	GameProperties.enemy_container = enemy_container
	round_manager.begin()
