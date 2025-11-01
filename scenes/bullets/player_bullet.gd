class_name PlayerBullet extends Area2D

const RADIUS := 16.0
const SPEED := 1600.0
const EXPLOSION_RADIUS := 50

@export var initial_color_id: Globals.COLOR_ID
@export var damage := 1 

@onready var color_component: ColorComponent = $ColorComponent
@onready var bullet_particles: CPUParticles2D = $BulletParticles
@onready var explosion_circle: Node2D = $ExplosionCircle
@onready var inner_explosion_circle: Node2D = $InnerExplosionCircle
@onready var explode_audio: AudioStreamPlayer = $ExplodeAudio

var angle_direction := PI*1.5
var disabled := false

func _ready():
	color_component.set_color_id(initial_color_id)

func _physics_process(delta: float) -> void:
	if disabled:
		return
	position.y += sin(angle_direction) * SPEED * delta
	position.x += cos(angle_direction) * SPEED * delta
	if position.x < -RADIUS or position.x > Globals.STAGE_WIDTH + RADIUS \
	or position.y < -300 or position.y > Globals.STAGE_HEIGHT + RADIUS:
		queue_free()

func _on_area_entered(area) -> void:
	if disabled: return
	if area is BulletComponent:
		area.destroy()
		return
	if area is HitboxComponent:
		disabled = true
		area.hit(damage, color_component.color_id)
		explode()

func explode():
	Globals.score += damage * 3 * (2 if Globals.SECONDARY_COLOR_MAP.has(color_component.color_id) else 1)
	explode_audio.play()
	bullet_particles.emitting = false
	explosion_circle.show()
	inner_explosion_circle.show()
	var main_tween = get_tree().create_tween()
	main_tween.set_parallel()
	main_tween.tween_property(explosion_circle, "radius", EXPLOSION_RADIUS, 0.4) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	main_tween.tween_property(explosion_circle, "modulate", Color.TRANSPARENT, 0.4)
	main_tween.tween_property(inner_explosion_circle, "radius", EXPLOSION_RADIUS, 0.6) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	var free_tween = get_tree().create_tween()
	free_tween.tween_property(inner_explosion_circle, "modulate", Color.TRANSPARENT, 0.6)
	free_tween.tween_callback(queue_free)
