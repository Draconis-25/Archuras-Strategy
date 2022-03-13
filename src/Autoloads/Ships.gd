extends Node

var list : Array

func _ready() -> void:
	list = list_files_in_directory(Config.resource_path + "Ships/")
	# for i in list:
	# 	print(i)

func list_files_in_directory(path : String):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			if file.ends_with(".obj"):
				files.append(file.get_basename())
	dir.list_dir_end()
	return files
