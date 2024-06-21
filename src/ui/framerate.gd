# framerate.gd
# Manages the FPS counter in the GUI

# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the terms of the daysant license.
# daysant@proton.me

extends Label

func _process(_delta):
	text=str(Engine.get_frames_per_second())
