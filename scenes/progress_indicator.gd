class_name ProgressIndicator extends Node

enum PROGRESS_TYPE {
	NORMAL,
	MINIBOSS,
	BOSS
}

@export var type: PROGRESS_TYPE

func begin():
	SignalBus.progress_indicator_reached.emit()
	queue_free()
