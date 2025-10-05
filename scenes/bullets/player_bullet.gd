extends Area2D

const RADIUS := 16.0
const SPEED := 1200.0


@export var initial_color_id: GameProperties.COLOR_ID
@onready var color_component: ColorComponent = $ColorComponent

var damage := 1 
var angle_direction := PI*1.5

func _ready():
	color_component.color_id = initial_color_id

func _physics_process(delta: float) -> void:
	position.y += sin(angle_direction) * SPEED * delta
	position.x += cos(angle_direction) * SPEED * delta
	if position.x < -RADIUS or position.x > GameProperties.STAGE_WIDTH + RADIUS \
	or position.y < -RADIUS or position.y > GameProperties.STAGE_HEIGHT + RADIUS:
		queue_free()

func _on_area_entered(area: HitboxComponent) -> void:
	queue_free()
	area.hit(damage, color_component.color_id)
