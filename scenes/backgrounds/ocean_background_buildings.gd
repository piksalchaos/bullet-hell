extends SubViewportContainer

const BUILDING_SPEED := 1.0
const BUILDING_MESH = preload("uid://cnrl577ysn660")
const SPAWN_TIMER_MAX := 1

var spawn_timer = SPAWN_TIMER_MAX

@onready var building_container: Node3D = $SubViewport/BuildingContainer


func _ready() -> void:
	pass
	for i in 50:
		spawn_building(true)

func _process(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_timer += SPAWN_TIMER_MAX
		spawn_building()
		
		
	for building: Node3D in building_container.get_children():
		building.position.z += BUILDING_SPEED * delta
		if building.position.z > 1:
			building.queue_free()

func spawn_building(randomize_z_position: bool = false):
	var building: Node3D = BUILDING_MESH.instantiate()
	building.position.x = randf_range(-18, 18)
	building.position.y = randf_range(-1, 2)
	if randomize_z_position:
		building.position.z = randf_range(-47, 0)
	else:
		building.position.z = -47
	building.rotation.y = randf() * 2 * PI
	building_container.add_child(building)
