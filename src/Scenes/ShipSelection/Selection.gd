extends Control

var rotating : bool = false
var prev_mouse_position : Vector2
var next_mouse_position : Vector2

var meshes : Array

var ships_data : Array

onready var ship : MeshInstance = $"Control/ViewportContainer/Viewport/Selection/MeshInstance"
onready var viewport : Viewport = $"Control/ViewportContainer/Viewport"
onready var viewport_con : ViewportContainer = $"Control/ViewportContainer"
onready var slider : HSlider = $"SelectionBar/HSlider"

onready var name_label : Label = $"Menu/Panel/VBoxContainer/Control/GridContainer/Name/Value"
onready var attack_label : Label = $"Menu/Panel/VBoxContainer/Control/GridContainer/Stat1/Value"
onready var defense_label : Label = $"Menu/Panel/VBoxContainer/Control/GridContainer/Stat2/Value"
onready var speed_label : Label = $"Menu/Panel/VBoxContainer/Control/GridContainer/Stat3/Value"
onready var capacity_label : Label = $"Menu/Panel/VBoxContainer/Control/GridContainer/Stat4/Value"
	
func _ready() -> void:
	slider.max_value = Ships.list.size() - 1
	for i in range(0, Ships.list.size()):
		var mesh = load(Config.resource_path + "Ships/" + Ships.list[i] + ".obj")
		meshes.append(mesh)
	ships_data = DevelopmentData.read_all("list", "res://res/Development/Data/ESSENTIAL/ships.db")

func _process(delta: float) -> void:
	ship.mesh = meshes[slider.value]
	name_label.text = Ships.list[slider.value].capitalize()

	attack_label.text = str(ships_data[slider.value]["attack"])
	defense_label.text = str(ships_data[slider.value]["defense"])
	speed_label.text = str(ships_data[slider.value]["speed"])
	capacity_label.text = str(ships_data[slider.value]["capacity"])
	
	viewport.size.x = viewport_con.rect_size.x 
	viewport.size.y = viewport_con.rect_size.y
	
	if Input.is_action_just_pressed("selection_rotate"):
		rotating = true
		prev_mouse_position = get_viewport().get_mouse_position()
	if Input.is_action_just_released("selection_rotate"):
		rotating = false
		
	if rotating:
		next_mouse_position = get_viewport().get_mouse_position()
		ship.rotate_y((next_mouse_position.x - prev_mouse_position.x) * .1 * delta)
		#ship.rotate_z(-(next_mouse_position.y - prev_mouse_position.y) * .1 * delta)
		prev_mouse_position = next_mouse_position


func _on_Select_pressed() -> void:
	DevelopmentData.ship = int(slider.value)
	Manager.set_scene("res://src/Scenes/CapitalSelection/CSelection.tscn")
