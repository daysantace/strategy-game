# title.gd
# Management for the title screen

# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the terms of the Affero GPL v3.0-or-later.
# daysant@proton.me

extends Control

func _ready():
	$VersionLabel.text = ProjectSettings.get_setting("application/config/version")
	Logger.Info("Version: "+ProjectSettings.get_setting("application/config/version"))
	Logger.Info("OS vendor: "+OS.get_name())

func _process(_delta):
	pass

func _on_play_button_down():
	get_tree().change_scene_to_file("res://src/planet/planet.tscn")
