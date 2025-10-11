extends Node

signal began

func begin() -> void:
	began.emit()
