extends Node

signal bullet_captured(captured_position: Vector2, color_id: GameProperties.COLOR_ID)

signal color_amount_changed(color_id: GameProperties.COLOR_ID, percentage: float)
signal selected_color_changed(color_id: GameProperties.COLOR_ID)
