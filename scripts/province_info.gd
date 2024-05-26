# province_info.gd
# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the terms of the AGPL v3.0-or-later
# daysant@proton.me

extends Node2D

var claimants

func _process(_delta):
	await get_tree().create_timer(0.001).timeout
		
	if not GlobalVar.selected_province:
		$province_name.text = "No province selected"
	else:
		$province_name.text = str(GlobalVar.selected_province.region_name)+"\nOwned by "+str(GlobalVar.selected_province.region_owner_name)
