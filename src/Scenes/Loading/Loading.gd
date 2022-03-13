extends Control

var value : float

func _process(_delta: float) -> void:
	$"VBoxContainer/ProgressBar".value = value