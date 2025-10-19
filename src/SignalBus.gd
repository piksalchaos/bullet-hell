extends Node

#signal color_amount_changed(color_id: Globals.COLOR_ID, percentage: float)
#signal selected_color_changed(color_id: Globals.COLOR_ID)

signal color_amount_changed(primary_color_index: int, percentage: float)
signal selected_color_changed(primary_color_index: int)
signal mixed_colors_changed(selected_primary_color_index: int, mixed_primary_color_index: int)
