extends WindowDialog

var key : int
var ip : String
var game_template : PackedScene = preload("res://src/Scenes/MainMenu/GameTemplate.tscn")

onready var games_list : VBoxContainer = $"TabContainer/Games/ScrollContainer/VBoxContainer"
onready var dropdown : OptionButton = $"TabContainer/New/VBoxContainer/Data/VBoxContainer/Type/Option"
onready var host : Control = $"TabContainer/New/VBoxContainer/Data/VBoxContainer/Host"
onready var join : Control = $"TabContainer/New/VBoxContainer/Data/VBoxContainer/Join"

func _ready() -> void:
	randomize()
	key = int(rand_range(999, 10000))
	print(key)
	if Config.development:
		var game_data = DevelopmentData.read_games()
		for i in range(0, game_data.size()):
			var template = game_template.instance()
			template.rect_size.x = self.rect_size.x - 5
			template.game_name = game_data[i]["name"]
			template.redirect_path = game_data[i]["path"]
			games_list.add_child(template)
	else:
		pass
	
	dropdown.add_item("Host")
	dropdown.add_item("Join")

	for l_ip in IP.get_local_addresses():
		if str(l_ip).split(".")[0] == "192":
			ip = l_ip
	
	print(ip)

	set_host_var()

func _on_Option_item_selected(index:int) -> void:
	if index == 0:
		host.visible = true
		join.visible = false
		$"TabContainer/New/VBoxContainer/Bottom/HBoxContainer/Button".text = "Create"
		$"TabContainer/New/VBoxContainer/Bottom/HBoxContainer/Control/Label".visible = false
		
	else:
		host.visible = false
		join.visible = true
		$"TabContainer/New/VBoxContainer/Bottom/HBoxContainer/Button".text = "Join"
		$"TabContainer/New/VBoxContainer/Bottom/HBoxContainer/Control/Label".visible = true

func set_host_var() -> void:
	$"TabContainer/New/VBoxContainer/Data/VBoxContainer/Host/VBoxContainer/IP/HBoxContainer2/LineEdit".text = str(ip)


func _on_KeyShow_pressed() -> void:
	pass # Replace with function body.


func _on_IPShow_pressed() -> void:
	$"TabContainer/New/VBoxContainer/Data/VBoxContainer/Host/VBoxContainer/IP/HBoxContainer2/LineEdit".secret = \
	!$"TabContainer/New/VBoxContainer/Data/VBoxContainer/Host/VBoxContainer/IP/HBoxContainer2/LineEdit".secret
