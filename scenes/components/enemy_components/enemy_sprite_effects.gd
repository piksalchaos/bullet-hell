extends Node2D

const MAX_VIBRATION_AMOUNT := 10.0
const VIBRATION_AMOUNT_DELTA := 40.0
const DEATH_SCALE = Vector2(1.25, 1.5)

var vibration_amount := 0.0

@export var hitbox_component: HitboxComponent
@export var health_component: HealthComponent
@export var pattern_root: Node2D
@export var sprite: Node2D
@export var free_parent_on_fade_end: bool = true

func _ready() -> void:
	if hitbox_component:
		hitbox_component.got_hit.connect(_on_hitbox_component_got_hit)
	if health_component:
		health_component.defeated.connect(_on_health_component_defeated)

func _on_health_component_defeated():
	var scale_tween = create_tween()
	scale_tween.tween_property(sprite, "scale", sprite.scale*DEATH_SCALE, 0.3) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	var transparency_tween = create_tween()
	transparency_tween.tween_property(sprite, "modulate", Color.TRANSPARENT, 0.3) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	if free_parent_on_fade_end:
		transparency_tween.tween_callback(get_parent().queue_free)
	if pattern_root:
		pattern_root.queue_free()

func _on_hitbox_component_got_hit():
	vibration_amount = MAX_VIBRATION_AMOUNT

func _process(delta: float) -> void:
	if vibration_amount > 0.0:
		sprite.position.x = randf_range(-1, 1) * vibration_amount
		vibration_amount -= VIBRATION_AMOUNT_DELTA * delta
