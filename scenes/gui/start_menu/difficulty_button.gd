extends Button

@onready var description_label: Label = $DescriptionLabel

func _ready() -> void:
	mouse_entered.connect(description_label.show)
	mouse_exited.connect(description_label.hide)
