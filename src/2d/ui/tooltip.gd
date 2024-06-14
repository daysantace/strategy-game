# tooltip.gd
# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the terms of the AGPL v3.0-or-later
# daysant@proton.me

extends Node2D

func _process(_delta):
	if $"../../provinces".mouse_over_province:
		visible = true
	else:
		visible = false
		
	position = get_viewport().get_mouse_position()
	$province_name.text = $"../../provinces".tooltip_text_province
