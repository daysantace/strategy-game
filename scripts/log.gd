# log.gd
# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the terms of the AGPL v3.0-or-later
# daysant@proton.me

extends Node

var logging_detail = 3

func info(text):
	if logging_detail>2:
		print_rich("[color=#ffffff]INFO  | "+str(text))

func debug(text):
	if logging_detail>1:
		print_rich("[color=#8888ff]DEBUG | At '"+str(Time.get_ticks_msec())+"' in '"+get_tree().current_scene.scene_file_path+"' by '"+get_stack()[1].source.get_file()+"' | "+str(text))
	
func warn(text):
	if logging_detail>0:
		print_rich("[color=#ffff88]WARN  | At '"+str(Time.get_ticks_msec())+"' in '"+get_tree().current_scene.scene_file_path+"' by '"+get_stack()[1].source.get_file()+"' | "+str(text))
	
func error(text):
	print_rich("[color=#ff8888]ERROR | At '"+str(Time.get_ticks_msec())+"' in '"+get_tree().current_scene.scene_file_path+"' by '"+get_stack()[1].source.get_file()+"' | "+str(text))
