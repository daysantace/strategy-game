# mesh.gd
# Applying meshing stuff for the planet

# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the terms of the daysant license.
# daysant@proton.me

extends MeshInstance3D

var n = 0

func _ready():
	var texture = load("res://src/planet/planets/earth/terrain.png")

	var heightmap = ResourceLoader.load(GameManager.planet+"heightmap.png")
	
	if not heightmap:
		Logger.Error("Could not load heightmap")
		return
	
	if not mesh:
		Logger.Error("Could not load mesh")
		return
		
	var array_mesh = mesh
	var new_mesh = ArrayMesh.new()

	for surface_index in range(array_mesh.get_surface_count()):
		var surface_arrays = array_mesh.surface_get_arrays(surface_index)
		if not surface_arrays:
			continue
		
		var vertices = surface_arrays[Mesh.ARRAY_VERTEX]
		var uvs = surface_arrays[Mesh.ARRAY_TEX_UV]

		for i in range(vertices.size()):
			var uv = uvs[i]
			var height = get_height_from_heightmap(heightmap, uv)
			var direction = vertices[i].normalized()
			vertices[i] += direction * height * 1.5

		surface_arrays[Mesh.ARRAY_VERTEX] = vertices

		new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_arrays)
	
	mesh = new_mesh
	
	var material = StandardMaterial3D.new()
	material.albedo_texture=texture
	set_surface_override_material(0,material)

func get_height_from_heightmap(heightmap, uv):
	var x = int(uv.x * (heightmap.get_width()-1))
	var y = int(uv.y * (heightmap.get_height()-1))
	var height = heightmap.get_pixel(x, y).r
	return height

func _process(_delta):
	pass
