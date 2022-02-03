extends Node

const SQLite : NativeScript = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

var db : SQLite
var db_name : String = "res://res/Development/Data/games.db"

var ship : int

func _ready() -> void:
	db = SQLite.new()
	db.path = db_name
	
func read_games() -> Array:
	db.open_db()
	db.query("select * from games;")
	var db_result : Array = db.query_result
	print_debug(db_result)
	return db_result
