extends Node2D

func begin() -> void:
	begin_upcoming_round()

func begin_upcoming_round() -> void:
	if get_child_count() == 0: return
	var round: Round = get_child(0)
	round.enemies_defeated.connect(goto_next_round)
	round.begin()

func goto_next_round() -> void:
	var previous_round = get_child(0)
	previous_round.tree_exited.connect(begin_upcoming_round)
	previous_round.queue_free()
