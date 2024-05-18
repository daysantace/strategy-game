# gen_provinces.gd
# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the terms of the AGPL v3.0-or-later
# daysant@proton.me

extends Node2D

@onready var image_source = "res://assets/map/testing.png"

var pixels_read = 0
var pixels_to_report = 100000
var total_pixels = 0

func _ready():
	global.provinces_loaded = false
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
		region.region_id = info.replace("#","").hex_to_int()
		region.set_name(info)
		
		$provinces.add_child(region)
		log_message.info("Added region " + str(region) + " '" + region.region_name + "' owned by " + regions_dict[info]["owner"])
		
		var polygons = get_polygons(image, info, pixel_colour_dict)

		for polygon in polygons:
			polygon = fix_polygon(polygon)
			
			var region_collision = CollisionPolygon2D.new()
			var region_polygon = Polygon2D.new()
			var polyline = Line2D.new()
			var sealine = Line2D.new()
			
			region.add_child(region_collision)
			region.add_child(region_polygon)
			region.add_child(polyline)
			
			region_collision.polygon = polygon
			region_polygon.polygon = polygon
			
			polyline.points = polygon
			polyline.closed = true
			polyline.width = 1.5
			polyline.z_index = 1
			
			$shore.add_child(sealine)
			sealine.points = polygon
			sealine.closed = true
			sealine.default_color = Color(0.255,0.576,0.824)
			sealine.width = 25.0
			sealine.z_index = -1
	
	global.provinces_loaded = true
	log_message.info("All provinces loaded")

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

	for i in $provinces.get_children():
		for other_polygon in i.get_children():
			if other_polygon.is_class("Polygon2D") and other_polygon.polygon!=new_polygon:
				var clip = Polygon2D.new()
				if !Geometry2D.intersect_polygons(new_polygon,other_polygon.polygon).is_empty():
					new_polygon=Geometry2D.clip_polygons(new_polygon,other_polygon.polygon)[0]
				else:
					pass

	return new_polygon
