extends Node

@export var bullet_emitters: Array[BulletEmitter]
@export var color_ids_to_choose: Array[Globals.COLOR_ID] = [
	Globals.COLOR_ID.RED, Globals.COLOR_ID.BLUE, Globals.COLOR_ID.YELLOW
]

var current_index = 0

func begin():
	current_index = (current_index + 1) % color_ids_to_choose.size()
	var color_id = color_ids_to_choose[current_index]
	for bullet_emitter in bullet_emitters:
		bullet_emitter.color_id = color_id
