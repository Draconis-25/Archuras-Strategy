extends Node

const SQLite : NativeScript = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

var db : SQLite
var db_name : String = "res://res/Development/Data/games.db"

var ship : int

var current_game : String = ""

func _ready() -> void:
	db = SQLite.new()
	
	
func read_all(_table : String, _db_path) -> Array:
	db.path = _db_path
	db.open_db()
	db.query("select * from " + _table + ";")
	var db_result : Array = db.query_result
	print_debug(db_result)
	return db_result

func add_game_hosted(_game_name : String, _game_path : String, _table : String) -> void:
	db.path = db_name
	db.open_db()
	db.query("insert into games (name, path, data) values ('" + _game_name + "', '" + _game_path + "', 'Selection');")

func add_game_joined(_game_name : String, _game_path : String, _host_ip : String, _game_key : String) -> void:
	db.path = db_name
	db.open_db()
	db.query("insert into joined (name, hostip, key, path) values ('" + _game_name + "', '" + _host_ip + "', '" + _game_key + "', '" + _game_path + "');")

func get_by_name(_name : String, _table : String, _db_path : String) -> Array:
	db.path = _db_path
	db.open_db()
	db.query("select * from " + _table + " where name = '" + _name + "';")
	var db_result : Array = db.query_result
	return db_result