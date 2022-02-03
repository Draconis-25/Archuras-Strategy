extends Control

export var game_name : String = "<GAME>"
export var redirect_path : String = "<PATH>"

func _process(_delta: float) -> void:
	$Button.text = game_name


func _on_Button_pressed() -> void:
	Manager.set_scene(redirect_path)
