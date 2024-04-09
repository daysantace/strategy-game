extends Node2D

@onready var image_source = "res://assets/map/ireland.png"

var pixels_read = 0
var pixels_to_report = 100000
var total_pixels = 0

func _ready():
	load_regions()

func _process(_delta):
	pass

func load_regions():
	var image = $map.get_texture().get_image()
	var pixel_colour_dict = get_pixel_colour_dict(image)
	var regions_dict = import_file("res://assets/map/provinces.txt")
	
	if regions_dict == null:
		return  # Exit the function if regions_dict is null
	
	log_message.info("Map loaded")
	
	for info in regions_dict:
		var region = load("res://scenes/province.tscn").instantiate()
		region.region_name = regions_dict[info]["provname"]
		region.region_owner = regions_dict[info]["owner"]
		region.set_name(info)
		get_node("provinces").add_child(region)
		log_message.info("Added region " + str(region) + " '" + region.region_name + "' owned by "+regions_dict[info]["owner"])
		
		var polygons = get_polygons(image, info, pixel_colour_dict)
		
		for polygon in polygons:
			var region_collision = CollisionPolygon2D.new()
			var region_polygon = Polygon2D.new()
			
			region_collision.polygon = polygon
			region_polygon.polygon = polygon
			
			region.add_child(region_collision)
			region.add_child(region_polygon)

func get_polygons(image,region_colour,pixel_colour_dict):
	var target_image=Image.create(image.get_size().x,image.get_size().y,false,Image.FORMAT_RGBA8)
	for value in pixel_colour_dict[region_colour]:
		target_image.set_pixel(value.x,value.y,"#ffffff")

	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(target_image)
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0,0),bitmap.get_size()),0.1)
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
			pixels_read+=1
			if pixels_read % pixels_to_report == 0:
					log_message.info(str(pixels_read)+"/"+str(image.get_width()*image.get_height())+" pixels read")

	return pixel_colour_dict

func import_file(filepath):
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file != null:
		return JSON.parse_string(file.get_as_text().replace("_", " "))
	else:
		log_message.error("Province map "+image_source+" not found")
		return null
