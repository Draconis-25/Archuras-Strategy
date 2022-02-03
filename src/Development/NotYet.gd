extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("mb"):
		Manager.set_scene("res://src/Scenes/MainMenu/Menu.tscn")
