extends Area2D


func _on_area_entered(collectible_component: Area2D) -> void:
	collectible_component.collect()
