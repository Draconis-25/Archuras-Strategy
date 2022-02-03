extends Control

onready var play_window : WindowDialog = $"PlayWindow"
onready var options_window : WindowDialog = $"OptionsWindow"

func _ready() -> void:
	if Config.development:
		pass

func _on_Play_pressed() -> void:
	play_window.popup_centered()


func _on_Options_pressed() -> void:
	options_window.popup_centered()


func _on_Exit_pressed() -> void:
	get_tree().quit()