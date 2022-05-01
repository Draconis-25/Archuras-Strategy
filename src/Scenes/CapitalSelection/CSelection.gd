extends Control

onready var viewport : Viewport = $"Control/ViewportContainer/Viewport"
onready var viewport_con : ViewportContainer = $"Control/ViewportContainer"

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	viewport.size.x = viewport_con.rect_size.x 
	viewport.size.y = viewport_con.rect_size.y
