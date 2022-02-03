extends CanvasLayer

func _physics_process(_delta: float) -> void:
	$"Label".text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
