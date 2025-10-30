extends Node

#signal color_amount_changed(color_id: Globals.COLOR_ID, percentage: float)
#signal selected_color_changed(color_id: Globals.COLOR_ID)

@warning_ignore_start("unused_signal")
signal color_amount_changed(primary_color_index: int, percentage: float)
signal selected_color_changed(primary_color_index: int)
signal mixed_colors_changed(mixed_primary_color_index: int)
signal cannot_perform_color_action()
signal found_color_to_mix_changed(found_color_to_mix: bool, color_id: Globals.COLOR_ID)

signal player_health_changed(new_player_health: int)

signal collected_color_collectible(color_id: Globals.COLOR_ID)
signal butterfly_collected

signal score_updated(new_score: int)
