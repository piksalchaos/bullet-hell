extends Node2D

const CLOUD_DRAWING = preload("uid://cu0uxg030b16a")
const SPAWN_CLOUD_TIMER_MAX := 0.05
const CLOUD_OFFSCREEN_DISTANCE := 200
const CLOUD_VELOCITY := Vector2(30, 30)

var spawn_cloud_timer = SPAWN_CLOUD_TIMER_MAX
@onready var cloud_container: Node2D = $CloudContainer

func _ready() -> void:
	for i in 200:
		new_cloud(Vector2(
			randf_range(-CLOUD_OFFSCREEN_DISTANCE, Globals.STAGE_WIDTH),
			randf_range(-CLOUD_OFFSCREEN_DISTANCE, Globals.STAGE_HEIGHT)
		))
	modulate = Color.TRANSPARENT
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 7)

func _process(delta: float) -> void:
	spawn_cloud_timer -= delta
	if spawn_cloud_timer <= 0:
		spawn_cloud_timer += SPAWN_CLOUD_TIMER_MAX
		new_cloud(create_cloud_position())
	
	for cloud in cloud_container.get_children():
		cloud.position += CLOUD_VELOCITY * (cloud.rect.size.x)/CLOUD_OFFSCREEN_DISTANCE * delta
		if (
			cloud.position.y > Globals.STAGE_HEIGHT + CLOUD_OFFSCREEN_DISTANCE
			or cloud.position.x > Globals.STAGE_WIDTH + CLOUD_OFFSCREEN_DISTANCE
		):
			cloud.queue_free()

func create_cloud_position() -> Vector2:
	var cloud_position := Vector2(-CLOUD_OFFSCREEN_DISTANCE, -CLOUD_OFFSCREEN_DISTANCE)
	if randf() > 0.5:
		cloud_position.x += (Globals.STAGE_WIDTH + CLOUD_OFFSCREEN_DISTANCE) * randf()
	else:
		cloud_position.y += (Globals.STAGE_HEIGHT + CLOUD_OFFSCREEN_DISTANCE) * randf()
	
	return cloud_position

func new_cloud(cloud_position: Vector2) -> void:
	var cloud = CLOUD_DRAWING.instantiate()
	cloud.position = cloud_position
	cloud_container.add_child(cloud)
