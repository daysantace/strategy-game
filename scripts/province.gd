# province.gd
# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the terms of the AGPL v3.0-or-later
# daysant@proton.me

extends Area2D

var region_name=""
var region_owner=""
var region_id=0
var colour
var init_already_done = false
var province_text_theme = preload("res://assets/themes/province_label.tres")
var mouse_is_over = false
var selected = false

func _ready():
	set_colour()

func _process(_delta):
	if mouse_is_over:
		global.mouse_over_province = true
	else:
		pass

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
	mouse_is_over = true
	global.tooltip_text_province = region_name
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.color=Color(colour.r+0.075,colour.g+0.075,colour.b+0.075,1)

func _on_mouse_exited():
	mouse_is_over = false
	global.mouse_over_province = false
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.color=colour

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		selected = !selected
		if selected:
			for node in get_children():
				if node.is_class("Line2D"):
						node.default_color=Color(1,1,0,1)
						node.z_index=2
		else:
			for node in get_children():
				if node.is_class("Line2D"):
						node.default_color=Color(1,1,1,1)
						node.z_index=0
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
