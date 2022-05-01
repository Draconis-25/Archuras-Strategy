extends Node

var current_scene = null
var max_load_time : int = 10000

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func set_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)

#wanna get a loading screen?
func goto_scene(path):
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

	var loader = ResourceLoader.load_interactive(path)
	
	if loader == null:
		print("Resource loader unable to load the resource at path")
		return
	
	var loading_bar = load("res://src/Scenes/Loading/Loading.tscn").instance()
	
	get_tree().get_root().call_deferred('add_child', loading_bar)
	
	var t = OS.get_ticks_msec()
	
	while OS.get_ticks_msec() - t < max_load_time:
		var err = loader.poll()
		if err == ERR_FILE_EOF:
			#Loading Complete
			var resource = loader.get_resource()
			get_tree().get_root().call_deferred('add_child', resource.instance())
			current_scene.queue_free()
			loading_bar.queue_free()
			break
			
		elif err == OK:
			#Still loading
			var progress = float(loader.get_stage()) / loader.get_stage_count()
			loading_bar.value = progress * 100
			print(progress)

		else:
			print("Error while loading file")
			break

		yield(get_tree(), "idle_frame")
