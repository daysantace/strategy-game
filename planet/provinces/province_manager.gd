# province_manager.gd
# Script to generate and manage provinces

# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the terms of the AGPL v3.0-or-later
# daysant@proton.me

extends Node2D
var provinces_loaded

@onready var image_source = GameManager.planet+"provinces.png"

var pixels_read = 0
var pixels_to_report = 100000
var total_pixels = 0
var num_threads = 4

var mouse_over_province = false
var selected_province = null
var tooltip_text_province = ""

func _ready():
	provinces_loaded = false
	load_regions()
	
func _process(_delta):
	pass

func load_regions():
	var image = load(image_source).get_image()
	var pixel_colour_dict = get_pixel_colour_dict(image)
	var regions_dict = import_file(GameManager.planet+"provinces.txt")
	
	if regions_dict == null:
		Logger.error("Regions dictionary file not found or failed to parse")
		return
		
	if image == null:
		Logger.error("Map image not found")
		return
	
	Logger.info("Map loaded")
	
	for info in regions_dict:
		var region = load("res://planet/provinces/province.tscn").instantiate()
		
		region.region_name = regions_dict[info]["provname"]
		region.region_owner = regions_dict[info]["owner"]
		region.region_id = info
		region.set_name(info)
		
		add_child(region)
		Logger.info("Added region " + str(region) + " '" + region.region_name + "' owned by " + regions_dict[info]["owner"])
		
		var polygons = get_polygons(image, info, pixel_colour_dict)

		for polygon in polygons:
			polygon = fix_polygon(polygon)
			
			var region_collision = CollisionPolygon2D.new()
			var region_polygon = Polygon2D.new()
			var polyline = Line2D.new()
			
			region.add_child(region_collision)
			region.add_child(region_polygon)
			region.add_child(polyline)
			
			region_collision.polygon = polygon
			region_polygon.polygon = polygon
			
			polyline.points = polygon
			polyline.closed = true
			polyline.width = 1.5
			polyline.z_index = 1

	provinces_loaded = true
	Logger.info("All provinces loaded")
							
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
	
	var threads = []
	var thread_data = []
	var thread_count = 8
	
	for i in range(thread_count):
		var start_row = (height * i) / thread_count
		var end_row = (height * (i + 1)) / thread_count
		thread_data.append({
			"start_row": start_row,
			"end_row": end_row,
			"partial_dict": {}
		})
		
		var thread = Thread.new()
		thread.start(process_rows.bind(image, width, height, start_row, end_row, thread_data[i]["partial_dict"]))
		threads.append(thread)
	
	for thread in threads:
		thread.wait_to_finish()
	
	for data in thread_data:
		for pixel_colour in data["partial_dict"]:
			if pixel_colour not in pixel_colour_dict:
				pixel_colour_dict[pixel_colour] = []
			pixel_colour_dict[pixel_colour] += data["partial_dict"][pixel_colour]
	
	return pixel_colour_dict

func process_rows(image, width, height, start_row, end_row, partial_dict):
	for y in range(start_row, end_row):
		for x in range(width):
			var pixel_colour = "#" + str(image.get_pixel(int(x), int(y)).to_html(false))
			if pixel_colour not in partial_dict:
				partial_dict[pixel_colour] = []
			partial_dict[pixel_colour].append(Vector2(x, y))

func import_file(filepath):
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file != null:
		return JSON.parse_string(file.get_as_text().replace("_", " "))
	else:
		Logger.error("Province map " + image_source + " not found")
		return null

func fix_polygon(polygon):
	var overfilled_polygon = []
	var new_polygon: PackedVector2Array = []
	
	overfilled_polygon = Geometry2D.offset_polygon(polygon,1.0,Geometry2D.JOIN_ROUND)[0]
	
	if polygon.size()>6:
		for i in range(overfilled_polygon.size()):
			if i%2 == 0:
				new_polygon.append(overfilled_polygon[i])
			else:
				pass
				
	else:
		return []

	for i in get_children():
		for other_polygon in i.get_children():
			if other_polygon.is_class("Polygon2D") and other_polygon.polygon!=new_polygon:
				if !Geometry2D.intersect_polygons(new_polygon,other_polygon.polygon).is_empty():
					new_polygon=Geometry2D.clip_polygons(new_polygon,other_polygon.polygon)[0]
				else:
					pass

	return new_polygon
