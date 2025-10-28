extends Node2D

const CIRCLE_DRAWING := preload("uid://dstuu3qr7iaia")
const PARTICLE_RADIUS := 16.0
const PARTICLE_DISTANCE := 100.0

@onready var particle_timer: Timer = $ParticleTimer
@onready var particle_container: Node2D = $ParticleContainer
@onready var success_particles: CPUParticles2D = $SuccessParticles

func start():
	particle_timer.start()

func stop():
	particle_timer.stop()

func emit_success_particles():
	success_particles.emitting = true

func spawn_particle():
	var particle = CIRCLE_DRAWING.instantiate()
	particle.radius = PARTICLE_RADIUS
	var random_angle = 2 * PI * randf()
	particle.position = Vector2(cos(random_angle), sin(random_angle)) * PARTICLE_DISTANCE
	var particle_color = Globals.COLORS[randi_range(0, 5)]
	particle.modulate = Color(particle_color, 0)
	
	var color_tween = create_tween()
	color_tween.tween_property(particle, "modulate", particle_color, 0.1)
	color_tween.tween_property(particle, "modulate", Color.WHITE, 0.4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	var position_tween = create_tween()
	position_tween.tween_property(particle, "position", Vector2.ZERO, 0.5)
	var queue_free_tween = create_tween()
	queue_free_tween.tween_property(particle, "scale", Vector2.ZERO, 0.5)
	queue_free_tween.tween_callback(particle.queue_free)
	
	particle_container.add_child(particle)

func _on_particle_timer_timeout() -> void:
	spawn_particle()
