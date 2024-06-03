# province.gd
# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the terms of the AGPL v3.0-or-later
# daysant@proton.me

extends Area2D

var region_name=""
var region_owner=""
var region_id=0
var colour
var mouse_is_over = false
var selected = false
var gotten_centre = false
var region_owner_name=""
var claimants = ""
var bordering = []
var country_dict = import_file("res://map/countries.txt")

var biggest_polygon
var incenter

func _ready():
	set_colour()

func _process(_delta):
	if mouse_is_over:
		$"..".mouse_over_province = true
	else:
		pass
		
	if $"..".provinces_loaded and not gotten_centre:
		gotten_centre = true
		biggest_polygon = get_biggest_polygon()
		incenter = find_incenter()
		
		for i in get_children():
			if i.is_class("Polygon2D"):
				var offset_polygon
				if !Geometry2D.offset_polygon(i.polygon,4.0).is_empty():
					offset_polygon = Geometry2D.offset_polygon(i.polygon,4.0)[0]
				else:
					continue
				for j in $"..".get_children():
					for k in j.get_children():
						if k.is_class("Polygon2D"):
							if !Geometry2D.offset_polygon(k.polygon,4.0).is_empty() and !(k==i):
								var other_polygon = Geometry2D.offset_polygon(k.polygon,4.0)[0]
								if !Geometry2D.intersect_polygons(offset_polygon,other_polygon).is_empty():
									if !bordering.has(j.region_id):
										bordering.append(j.region_id)
									else:
										continue
							else:
								continue
						else:
							continue
			
func get_province_by_id(id):
	for i in $"..".get_children():
		if i.name == id:
			return i

func set_colour():
	region_owner_name = country_dict[region_owner]["name"]

	if country_dict.has(region_owner):
		var colour_str = country_dict[region_owner]["colour"]
		colour = Color(colour_str.substr(1))
		colour = Color(colour.r,colour.g,colour.b,1)
	else:
		Logger.warn("Region owner '" + region_owner + "' not found in country dictonary")
		colour = Color8(128,128,128)
	
func _on_child_entered_tree(node):
	if node.is_class("Polygon2D"):
		node.color=colour

func _on_mouse_entered():
	mouse_is_over = true
	$"..".mouse_over_province = true
	$"..".tooltip_text_province = region_name
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.color=Color(colour.r+0.075,colour.g+0.075,colour.b+0.075,1)

func _on_mouse_exited():
	mouse_is_over = false
	$"..".mouse_over_province = false
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.color=colour

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if mouse_is_over:
			$"..".selected_province = self
			selected = true
		else:
			$"..".selected_province = null
			selected = false


func import_file(filepath):
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file != null:
		var file_contents = file.get_as_text()
		var parsed_json = JSON.parse_string(file_contents.replace("_", " "))
		if parsed_json == null:
			Logger.error("Error parsing JSON file: " + filepath)
		else:
			return parsed_json
	else:
		Logger.error("Failed to open file: " + filepath)
	return null

# welcome to the sea of ai generated nonsense because i have no clue how geometry works

func distance_point_to_segment(point: Vector2, segment_start: Vector2, segment_end: Vector2) -> float:
	var segment_vector = segment_end - segment_start
	var point_vector = point - segment_start
	var t = point_vector.dot(segment_vector) / segment_vector.length_squared()
	t = clamp(t, 0.0, 1.0)
	var projection = segment_start + t * segment_vector
	return point.distance_to(projection)

func distance_to_polygon_edges(point: Vector2, polygon: PackedVector2Array) -> float:
	var min_distance = INF
	for i in range(polygon.size()):
		var segment_start = polygon[i]
		var segment_end = polygon[(i + 1) % polygon.size()]
		var distance = distance_point_to_segment(point, segment_start, segment_end)
		min_distance = min(min_distance, distance)
	return min_distance

func initial_incenter_estimate(polygon: PackedVector2Array) -> Vector2:
	var bounds = get_bounds(polygon)
	var min_x = bounds.position.x
	var min_y = bounds.position.y
	var max_x = bounds.position.x + bounds.size.x
	var max_y = bounds.position.y + bounds.size.y
	
	var grid_size = 10.0
	var best_point = Vector2()
	var max_distance = 0.0
	
	for x in range(min_x, max_x, grid_size):
		for y in range(min_y, max_y, grid_size):
			var point = Vector2(x, y)
			if Geometry2D.is_point_in_polygon(point, polygon):
				var distance = distance_to_polygon_edges(point, polygon)
				if distance > max_distance:
					max_distance = distance
					best_point = point
					
	return best_point

func refine_incenter(polygon: PackedVector2Array, initial_point: Vector2) -> Vector2:
	var point = initial_point
	var step_size = 1.0
	var improvement = true
	
	while improvement:
		improvement = false
		var best_point = point
		var max_distance = distance_to_polygon_edges(point, polygon)
		
		for dx in [-step_size, 0, step_size]:
			for dy in [-step_size, 0, step_size]:
				if dx == 0 and dy == 0:
					continue
				var candidate = point + Vector2(dx, dy)
				if Geometry2D.is_point_in_polygon(point, polygon):
					var distance = distance_to_polygon_edges(candidate, polygon)
					if distance > max_distance:
						max_distance = distance
						best_point = candidate
						improvement = true
						
		point = best_point
		
	return point
	
func find_incenter():
	var initial_point = initial_incenter_estimate(get_biggest_polygon())
	return refine_incenter(get_biggest_polygon(), initial_point)

func get_biggest_polygon():
	biggest_polygon = null
	var biggest_polygon_area = 0

	for polygon in get_children():
		if polygon.is_class("Polygon2D"):
			var n = polygon.polygon.size()
			
			if n == 0:
				continue
			
			var area = 0.0
			var j = n - 1

			for i in range(n):
				var vertex_i = polygon.polygon[i]
				var vertex_j = polygon.polygon[j]
				area += (vertex_j.x + vertex_i.x) * (vertex_j.y - vertex_i.y)
				j = i

			area = abs(area) / 2.0

			if area > biggest_polygon_area:
				biggest_polygon_area = area
				biggest_polygon = polygon

	if biggest_polygon == null:
		Logger.error("Could not find Polygon2D")
	else:
		return biggest_polygon.polygon

func get_bounds(polygon: PackedVector2Array) -> Rect2:
	var min_x = INF
	var min_y = INF
	var max_x = -INF
	var max_y = -INF

	for point in polygon:
		if point.x < min_x:
			min_x = point.x
		if point.y < min_y:
			min_y = point.y
		if point.x > max_x:
			max_x = point.x
		if point.y > max_y:
			max_y = point.y

	return Rect2(Vector2(min_x, min_y), Vector2(max_x - min_x, max_y - min_y))
