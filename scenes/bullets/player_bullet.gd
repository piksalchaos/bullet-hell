extends Area2D

const RADIUS := 16.0
const SPEED := 1600.0


@export var initial_color_id: Globals.COLOR_ID
@export var damage := 1 

@onready var color_component: ColorComponent = $ColorComponent

var angle_direction := PI*1.5

func _ready():
	color_component.set_color_id(initial_color_id)

func _physics_process(delta: float) -> void:
	position.y += sin(angle_direction) * SPEED * delta
	position.x += cos(angle_direction) * SPEED * delta
	if position.x < -RADIUS or position.x > Globals.STAGE_WIDTH + RADIUS \
	or position.y < -RADIUS or position.y > Globals.STAGE_HEIGHT + RADIUS:
		queue_free()

func _on_area_entered(area: HitboxComponent) -> void:
	queue_free()
	area.hit(damage, color_component.color_id)
