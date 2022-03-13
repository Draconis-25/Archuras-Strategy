extends WorldEnvironment

export(int,1,10) var noise_octaves = 6
export(float) var noise_period = 8.0
export(float) var noise_persistence = 0.8

onready var mesh_original = $planet/Planet.mesh

func _ready():
	seed(OS.get_ticks_msec())
	make_planet()

func _input(event):
	if event.is_action_pressed("ui_accept"):
			make_planet()
	
func make_planet():
	var surf = MeshDataTool.new()
	surf.create_from_surface(mesh_original, 0)

	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = noise_octaves
	noise.period = noise_period
	noise.persistence = noise_persistence

	# Add a randomness to the 4th dimension, otherwise we are only on the 
	# 3d points of the sphere, which are the same...
	var dim = rand_range(-1,1)

	# push/pull all vertices (this is the slow part)
	for i in range(surf.get_vertex_count()):
		var v = surf.get_vertex(i)
		var norm = surf.get_vertex_normal(i)

		var n = noise.get_noise_4d(v.x, v.y, v.z, dim)

		v += n * norm * dim

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

func _process(delta):
	$cam_root.rotate_y(delta / 3)
