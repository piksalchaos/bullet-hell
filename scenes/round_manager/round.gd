class_name Round extends Node2D

@export var spawner_container: Node2D = self
@export var is_disabled: bool = false

func _ready():
	hide()
	spawner_container.child_order_changed.connect(_on_spawner_container_child_order_changed)

func begin() -> void:
	if is_disabled:
		queue_free()
		return
	show()
	var spawner_children = get_spawner_children()
	if spawner_children.is_empty(): spawner_container.queue_free()
	for spawner in spawner_children:
		if spawner.has_method("begin"):
			spawner.begin()

func _on_spawner_container_child_order_changed() -> void:
	if get_spawner_children().is_empty(): spawner_container.queue_free()

func get_spawner_children() -> Array:
	var spawner_children = []
	for child in spawner_container.get_children():
		if child.is_in_group("spawners") and child != self:
			spawner_children.append(child)
	return spawner_children
