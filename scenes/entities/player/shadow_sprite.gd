extends AnimatedSprite2D

@onready var color_component: ColorComponent = $ColorComponent

func _ready() -> void:
	SignalBus.selected_color_changed.connect(change_color)

func change_color(primary_color_index):
	color_component.set_color_id_with_tween(Globals.PRIMARY_COLORS[primary_color_index], 0.1)
