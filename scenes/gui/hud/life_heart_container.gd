extends HBoxContainer

func _ready() -> void:
	#set_deferred("size", Vector2(Globals.max_player_health * 64, size.y))
	size.x = Globals.max_player_health * 64
	position.x = 200 - size.x/2
