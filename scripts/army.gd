# army.gd
# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the terms of the AGPL v3.0-or-later
# daysant@proton.me

extends Control

var selected = false
var mouse_over = false
var location = ""
var commander = ""
var type = "infantry"
var set_selected = false

func _ready():
	var flag_texture = load("res://assets/flags/flag"+commander+".svg")
	if flag_texture:
		$flag.texture=flag_texture
	else:
		Logger.error("Flag texture not identified for "+commander)
	fix_unit_colour()

func _process(_delta):
	if selected:
		$selected_border.visible = true
	else:
		$selected_border.visible = false
		
func fix_unit_colour():
	if commander == GlobalVar.player:
		$num_background.color = Color(0.0,0.388,0.188)
	else:
		$num_background.color = Color(0.33,0.33,0.33)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if Input.is_action_pressed("gameplay_select_multiple"):
			pass
		elif GlobalVar.selected_army == self:
			pass
		else:
			selected = false

func _on_pressed():
	GlobalVar.selected_army == self
	if commander == GlobalVar.player:
		if Input.is_action_pressed("gameplay_select_multiple"):
			selected = !selected
		else:
			selected = true
