# title.gd
# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the terms of the AGPL v3.0-or-later
# daysant@proton.me

extends Control

func _ready():
	Logger.info("Version: Build 20240526")
	Logger.info("OS vendor: "+OS.get_name())
	pass

func _process(delta):
	pass
	
func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/map.tscn")

func _on_exit_pressed():
	get_tree().quit()

func _on_credits_pressed():
	Logger.info("This has not been implemented yet")

func _on_options_pressed():
	Logger.info("This has not been implemented yet")
