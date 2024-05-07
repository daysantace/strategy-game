# province.gd
# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the terms of the AGPL v3.0-or-later
# daysant@proton.me

extends Area2D

var region_name=""
var region_owner=""
var region_id=0
var colour
var gotten_centre = false

func _ready():
	set_colour()

func _process(_delta):
	if global.provinces_loaded and not gotten_centre:
		gotten_centre = true
		var centroid = get_centroid()
		$label.text = region_name
		$label.z_index = z_index+1
		$label.position = Vector2(centroid.x-($label.get_minimum_size().x/2),centroid.y-($label.get_minimum_size().y/2))
		
	if global.zoom_level<2:
		$label.visible = false
	else:
		$label.visible = true
func set_colour():
	var country_dict = import_file("res://assets/map/countries.txt")

	if country_dict.has(region_owner):
		var colour_str = country_dict[region_owner]["colour"]
		colour = Color(colour_str.substr(1))
		colour = Color(colour.r,colour.g,colour.b,1)
	else:
		log_message.warn("Region owner '" + region_owner + "' not found in country dictonary")
		colour = Color8(128,128,128)
	
func _on_child_entered_tree(node):
	if node.is_class("Polygon2D"):
		node.color=colour

func _on_mouse_entered():
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.color=Color(colour.r+0.075,colour.g+0.075,colour.b+0.075,1)

func _on_mouse_exited():
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.color=colour

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		pass

func import_file(filepath):
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file != null:
		var file_contents = file.get_as_text()
		var parsed_json = JSON.parse_string(file_contents.replace("_", " "))
		if parsed_json == null:
			log_message.error("Error parsing JSON file: " + filepath)
		else:
			return parsed_json
	else:
		log_message.error("Failed to open file: " + filepath)
	return null

func get_centroid():
	var biggest_polygon
	var biggest_polygon_area = 0
	
	for polygon in get_children():
		if polygon.is_class("Polygon2D"):
			var n = polygon.polygon.size()
			var area = 0.0
			var j = n - 1

			for i in range(n):
				var vertex_i = polygon.polygon[i]
				var vertex_j = polygon.polygon[j]
				area += (vertex_j.x + vertex_i.x) * (vertex_j.y - vertex_i.y)
				j = i

			area = abs(area) / 2.0
			if area>biggest_polygon_area:
				biggest_polygon_area = area
				biggest_polygon = polygon
				
	var polygon = biggest_polygon.polygon
	var area = biggest_polygon_area
	
	var centroid = Vector2(0, 0)
	var num_vertices = polygon.size()

	for i in range(num_vertices):
		var current_vertex = polygon[i]
		var next_vertex = polygon[(i + 1) % num_vertices]
		var cross_product = current_vertex.cross(next_vertex)
		centroid += (current_vertex + next_vertex) * cross_product
	centroid /= (6 * area)
	
	return centroid
