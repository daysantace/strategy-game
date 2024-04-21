# province.gd
# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the terms of the AGPL v3.0-or-later
# daysant@proton.me

extends Area2D

var region_name=""
var region_owner=""
var region_id=0
var colour

func _ready():
	z_index=region_id
	set_colour()

func set_colour():
	var country_dict = import_file("res://assets/map/countries.txt")

	if country_dict.has(region_owner):
		var colour_str = country_dict[region_owner]["colour"]
		colour = Color(colour_str.substr(1))
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
