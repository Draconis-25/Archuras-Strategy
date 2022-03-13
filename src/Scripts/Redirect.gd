extends Control

func _ready() -> void:
	if DevelopmentData.current_game == "":
		Manager.set_scene("res://src/Scenes/MainMenu/Menu.tscn")
	else:
		var data = str(DevelopmentData.current_game)
		var game_data : Array = DevelopmentData.get_by_name(data, "games", "res://res/Development/Data/games.db")
		if game_data[0]["data"] == "Selection":
			Manager.goto_scene("res://src/Scenes/ShipSelection/Selection.tscn")
