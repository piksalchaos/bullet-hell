extends SubViewportContainer

const BUILDING_SPEED = 0.3

@onready var building_container: Node3D = $SubViewport/BuildingContainer

func _process(delta: float) -> void:
	pass
	#for building: Node3D in building_container.get_children():
		#building.position.z += BUILDING_SPEED * delta
