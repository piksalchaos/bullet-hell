extends TextureButton

const HOVER_SCALE = Vector2(1.1, 1.1)

func _ready():
	mouse_entered.connect(scale_up)
	mouse_exited.connect(scale_down)

func scale_up():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", HOVER_SCALE, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func scale_down():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
