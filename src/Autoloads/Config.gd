extends Node

export var development : bool = true

var resource_path : String

func _ready() -> void:
	if development:
		resource_path = "res://res/Development/"
	else:
		resource_path = "res://res/Final/"
