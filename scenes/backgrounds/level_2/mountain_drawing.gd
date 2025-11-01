extends Node2D
@onready var polygon_2d: Polygon2D = $Polygon2D

func _ready():
	for i in polygon_2d.polygon.size():
		if i != 0:
			polygon_2d.polygon[i].y += randf() * 30.0
