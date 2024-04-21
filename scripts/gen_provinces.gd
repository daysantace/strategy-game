# gen_provinces.gd
# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the terms of the AGPL v3.0-or-later
# daysant@proton.me

extends Node2D

@onready var image_source = "res://assets/map/testing.png"

var pixels_read = 0
var pixels_to_report = 100000
var total_pixels = 0
var simplification_tolerance = 1.1 # for douglas-peucker for provinces

func _ready():
	load_regions()

func _process(_delta):
	pass

func load_regions():
	var image = $map.get_texture().get_image()
	var pixel_colour_dict = get_pixel_colour_dict(image)
	var regions_dict = import_file("res://assets/map/provinces.txt")
	
	if regions_dict == null:
		log_message.error("Regions dictionary file not found or failed to parse")
		return
		
	if image == null:
		log_message.error("Map image not found")
		return
	
	log_message.info("Map loaded")
	
	for info in regions_dict:
		var region = load("res://scenes/province.tscn").instantiate()
		region.region_name = regions_dict[info]["provname"]
		region.region_owner = regions_dict[info]["owner"]
		region.set_name(info)
		get_node("provinces").add_child(region)
		log_message.info("Added region " + str(region) + " '" + region.region_name + "' owned by " + regions_dict[info]["owner"])
		
		var polygons = get_polygons(image, info, pixel_colour_dict)
		polygons = simplify_polygons(polygons)

		for polygon in polygons:
			var region_collision = CollisionPolygon2D.new()
			var region_polygon = Polygon2D.new()
			
			var polygon_offset = Geometry2D.offset_polygon(polygon,1.0,Geometry2D.JOIN_MITER)
			if not polygon_offset.is_empty():
				polygon = polygon_offset[0]
			
			region_collision.polygon = polygon
			region_polygon.polygon = polygon
			
			region.add_child(region_collision)
			region.add_child(region_polygon)

func get_polygons(image, region_colour, pixel_colour_dict):
	var target_image = Image.create(image.get_size().x, image.get_size().y, false, Image.FORMAT_RGBA8)
	for value in pixel_colour_dict[region_colour]:
		target_image.set_pixel(value.x, value.y, Color.WHITE)

	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(target_image)
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0, 0), bitmap.get_size()), 0.1)
	return polygons

func get_pixel_colour_dict(image):
	var pixel_colour_dict = {}
	var width = image.get_width()
	var height = image.get_height()

	for y in range(height):
		for x in range(width):
			var pixel_colour = "#" + str(image.get_pixel(int(x), int(y)).to_html(false))
			if pixel_colour not in pixel_colour_dict:
				pixel_colour_dict[pixel_colour] = []
			pixel_colour_dict[pixel_colour].append(Vector2(x, y))
			pixels_read += 1
			if pixels_read % pixels_to_report == 0:
				log_message.info(str(pixels_read) + "/" + str(image.get_width() * image.get_height()) + " pixels read")

	return pixel_colour_dict

func import_file(filepath):
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file != null:
		return JSON.parse_string(file.get_as_text().replace("_", " "))
	else:
		log_message.error("Province map " + image_source + " not found")
		return null

func simplify_polygons(polygons):
	var simplified_polygons = []
	for polygon in polygons:
		var simplified_polygon = douglas_peucker(polygon, simplification_tolerance)
		simplified_polygons.append(simplified_polygon)
	return simplified_polygons

func douglas_peucker(points, tolerance):
	var max_distance = 0.0
	var max_index = 0

	var end_index = points.size() - 1

	for i in range(1, end_index):
		var distance = perpendicular_distance(points[i], points[0], points[end_index])
		if distance > max_distance:
			max_distance = distance
			max_index = i

	if max_distance > tolerance:
		var first_segment = points.slice(0, max_index + 1)
		var second_segment = points.slice(max_index)

		var simplified_first_segment = douglas_peucker(first_segment, tolerance)
		var simplified_second_segment = douglas_peucker(second_segment, tolerance)

		return simplified_first_segment.slice(0, -1) + simplified_second_segment
	else:
		return [points[0], points[end_index]]
		
func perpendicular_distance(point, line_start, line_end):
	var x = point.x
	var y = point.y
	var x1 = line_start.x
	var y1 = line_start.y
	var x2 = line_end.x
	var y2 = line_end.y

	var A = x - x1
	var B = y - y1
	var C = x2 - x1
	var D = y2 - y1

	var dot = A * C + B * D
	var len_sq = C * C + D * D
	var param = -1
	if len_sq != 0:
		param = dot / len_sq

	var xx
	var yy

	if param < 0:
		xx = x1
		yy = y1
	elif param > 1:
		xx = x2
		yy = y2
	else:
		xx = x1 + param * C
		yy = y1 + param * D

	var dx = x - xx
	var dy = y - yy

	return sqrt(dx * dx + dy * dy)
