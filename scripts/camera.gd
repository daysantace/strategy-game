# camera.gd
# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the terms of the AGPL v3.0-or-later
# daysant@proton.me

extends Camera2D

var acceleration = 0

func _process(delta):
	var viewport_size = get_viewport_rect().size
	var pan_direction = Vector2()
	var diag_fix=1
	
	if get_viewport().get_mouse_position().x < 1:
		pan_direction.x = -1
	elif get_viewport().get_mouse_position().x > viewport_size.x-2:
		pan_direction.x = 1

	if get_viewport().get_mouse_position().y < 1:
		pan_direction.y = -1
	elif get_viewport().get_mouse_position().y > viewport_size.y-2:
		pan_direction.y = 1
	
	if acceleration<500:
		acceleration+=100
	
	if pan_direction.y==0 and pan_direction.x==0:
		acceleration=0
	
	if pan_direction.y!=0 and pan_direction.x!=0:
		diag_fix=sqrt(2)
	
	if Input.is_action_just_pressed("cam_in"):
		global.zoom_level-=0.05
	if Input.is_action_just_pressed("cam_out"):
		global.zoom_level+=0.05
	global.zoom_level=clamp(global.zoom_level,0.1,5)
	zoom=Vector2(global.zoom_level,global.zoom_level)
	
	position += ((pan_direction * (100+acceleration) * delta)/diag_fix)/global.zoom_level
