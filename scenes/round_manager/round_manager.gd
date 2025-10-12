extends Node2D

signal finished

func begin() -> void:
	begin_upcoming_round()

func begin_upcoming_round() -> void:
	if get_child_count() == 0:
		finished.emit()
		return
	var upcoming_round = get_child(0)
	#upcoming_round.enemies_defeated.connect(goto_next_round)
	if not upcoming_round.is_connected("tree_exited", begin_upcoming_round):
		upcoming_round.tree_exited.connect(begin_upcoming_round)
	upcoming_round.begin()

func goto_next_round() -> void:
	var previous_round = get_child(0)
	previous_round.tree_exited.connect(begin_upcoming_round)
	previous_round.queue_free()
