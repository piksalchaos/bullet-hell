extends Node2D

const CIRCLE_DRAWING := preload("uid://dstuu3qr7iaia")
const PARTICLE_RADIUS := 8.0
const PARTICLE_DISTANCE := 75.0

@onready var particle_timer: Timer = $ParticleTimer
@onready var particle_container: Node2D = $ParticleContainer

func start():
	particle_timer.start()

func stop():
	particle_timer.stop()

func spawn_particle():
	var particle = CIRCLE_DRAWING.instantiate()
	particle.radius = PARTICLE_RADIUS
	var random_angle = 2 * PI * randf()
	particle.position = Vector2(cos(random_angle), sin(random_angle)) * PARTICLE_DISTANCE
	particle.modulate = Color.TRANSPARENT
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(particle, "modulate", Color.WHITE, 0.2)
	tween.tween_property(particle, "position", Vector2.ZERO, 0.5)
	var queue_free_tween = create_tween()
	queue_free_tween.tween_property(particle, "scale", Vector2.ZERO, 0.5)
	queue_free_tween.tween_callback(particle.queue_free)
	
	particle_container.add_child(particle)

func _on_particle_timer_timeout() -> void:
	spawn_particle()
