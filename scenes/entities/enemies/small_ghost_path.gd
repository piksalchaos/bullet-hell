extends Path2D

@export var enemy_scene: PackedScene
@export var initial_color_id: Globals.COLOR_ID
@export var number_of_enemies: int = 3
@export var time_between_spawns: float = 0.5

@onready var spawn_timer: Timer = $SpawnTimer
@onready var pattern_repeater: Node2D = $PatternRepeater
@onready var signal_emitter: Node = $PatternRepeater/SignalEmitter

var number_of_enemies_spawned: int = 0
var number_of_enemies_freed: int = 0

func _ready():
	spawn_timer.wait_time = time_between_spawns
	spawn_enemy()
	spawn_timer.start()
	pattern_repeater.begin()

func spawn_enemy():
	number_of_enemies_spawned += 1
	if number_of_enemies_spawned >= number_of_enemies:
		spawn_timer.stop()
	var enemy = enemy_scene.instantiate()
	enemy.initial_color_id = initial_color_id
	signal_emitter.began.connect(enemy.shoot)
	add_child(enemy)

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()

func _on_child_exiting_tree(node: Node) -> void:
	if not node is PathFollow2D: return
	number_of_enemies_freed += 1
	if number_of_enemies_freed == number_of_enemies:
		queue_free()
