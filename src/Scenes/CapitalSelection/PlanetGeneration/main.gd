extends WorldEnvironment

onready var progress = $container/progress
onready var mesh_original = $planet/Planet.mesh

func _ready():
	seed(OS.get_ticks_msec())
	make_planet()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if !progress.visible:
			make_planet()
	
func make_planet():
		
	var surf = MeshDataTool.new()
	surf.create_from_surface(mesh_original, 0)
	
	#show the progress bar
	progress.show()
	
	var max_iterations = 145 #145  
	for j in range(max_iterations):
		
		# wait a frame to prevent freezing the game
		yield(get_tree(), "idle_frame")
		
		# show progress in the progress bar
		progress.max_value = max_iterations
		progress.value = j
		
		var dir = Vector3(rand_range(-1,1), rand_range(-1,1), rand_range(-1,1)).normalized()
		
		# push/pull all vertices (this is the slow part)
		for i in range(surf.get_vertex_count()):
			var v = surf.get_vertex(i)
			var norm = surf.get_vertex_normal(i)
			
			var dot = norm.normalized().dot(dir)
			var sharpness = 50  # how sharp the edges are
			dot = exp(dot*sharpness) / (exp(dot*sharpness) + 1) - 0.5 # sigmoid function
			
			v += dot * norm * 0.01
			
			surf.set_vertex(i, v)
	
	var min_dist = 0.9 # deep sea
	var max_dist = 1.1 # mountains
	
	#finally set uv.x according to distance to center, which colors the terrain depending on elevation
	
	for i in range(surf.get_vertex_count()):
		var v = surf.get_vertex(i)
		var dist = v.length() 
		var dist_normalized = range_lerp(dist, min_dist, max_dist, 0, 1) # bring dist to 0..1 range
		
		var uv = Vector2(dist_normalized, 0)
		surf.set_vertex_uv(i, uv)

	#also recalculate face normals (TODO smooth 'em!)
	
	for i in range(surf.get_face_count()):
		
		var v1i = surf.get_face_vertex(i,0)
		var v2i = surf.get_face_vertex(i,1)
		var v3i = surf.get_face_vertex(i,2)
		
		var v1 = surf.get_vertex(v1i)
		var v2 = surf.get_vertex(v2i)
		var v3 = surf.get_vertex(v3i)
		
		# calculate normal for this face
		var norm = -(v2 - v1).normalized().cross((v3 - v1).normalized()).normalized()
		
		surf.set_vertex_normal(v1i, norm)
		surf.set_vertex_normal(v2i, norm)
		surf.set_vertex_normal(v3i, norm)
		
	# commit the mesh
	var mmesh = ArrayMesh.new() 
	surf.commit_to_surface(mmesh)
	$planet/Planet.mesh = mmesh
	
	# hide the progress bar
	progress.hide()


func _process(delta):
	$cam_root.rotate_y(delta / 3)
