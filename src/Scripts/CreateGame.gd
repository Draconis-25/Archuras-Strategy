extends Node

var mode : String
var username : String

#Host Variables
var game_name : String

#Join Variables
var key : int
var target_ip : int

func _prepare_strings(string : String) -> String:
	string = string.replace("\\", "")
	string = string.replace("=", "")
	string = string.replace("<", "")
	string = string.replace(">", "")
	string = string.replace("*", "")
	string = string.replace("^", "")
	string = string.replace(" ", "")
	return string

func prepare_strings() -> void:
	username = _prepare_strings(username)
	if mode == "Host":
		game_name = _prepare_strings(game_name)
	elif mode == "Join":
		pass
	else:
		pass

func create_files(_game_name : String) -> void:
	if Config.development:
		var directory = Directory.new()
		directory.open("res://res/Development/Data")
		directory.make_dir(_game_name)
		if true:
			var dir = Directory.new()
			dir.open("res://res/Development/Data/TEMPLATE/")
			dir.list_dir_begin()
			while true:
				var file = dir.get_next()
				if file == "":
					break
				elif not file.begins_with("."):
					if not file.ends_with(".import"):
						directory.copy("res://res/Development/Data/TEMPLATE/" + file, "res://res/Development/Data/" + _game_name + "/" + file)
			dir.list_dir_end()
		
#turn this two to bool
func create_new_game() -> void:
	if mode == "Host":
		prepare_strings()
		create_files(game_name)
		DevelopmentData.add_game(game_name, "res://src/Scripts/Redirect.tscn")

func join_new_game() -> void:
	pass