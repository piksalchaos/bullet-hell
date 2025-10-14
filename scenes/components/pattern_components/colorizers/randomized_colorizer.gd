extends Node

@export var bullet_emitters: Array[BulletEmitter]
@export var color_ids_to_choose: Array[Globals.COLOR_ID] = [
	Globals.COLOR_ID.RED, Globals.COLOR_ID.BLUE, Globals.COLOR_ID.YELLOW
]

func begin():
	var random_color_id = color_ids_to_choose[randi_range(0, color_ids_to_choose.size()-1)]
	for bullet_emitter in bullet_emitters:
		bullet_emitter.color_id = random_color_id
