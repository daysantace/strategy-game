# camera.gd
# Camera pan and zoom

# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the terms of the Affero GPL v3.0-or-later.
# daysant@proton.me

extends Node3D

var rotation_sensitivity = 0.1
var zoom_sensitivity = 1.0
var min_fov = 3.0
var max_fov = 90.0
var previous_mouse_position : Vector2
var pitch = 0.0
var yaw = 0.0
@onready var camera = $Camera

func _ready():
	previous_mouse_position = get_viewport().get_mouse_position()
	set_process_input(true)

func _input(event: InputEvent):
	if Input.is_action_pressed("camera_pan"):
		if event is InputEventMouseMotion:
			var mouse_delta: Vector2 = event.relative
			
			yaw -= mouse_delta.x * rotation_sensitivity
			pitch -= mouse_delta.y * rotation_sensitivity
			
			pitch = clamp(pitch, -89, 89)
			
			rotation_degrees.y = yaw
			rotation_degrees.x = pitch
			rotation_degrees.z = 0
	else:
		previous_mouse_position = get_viewport().get_mouse_position()
		
		if Input.is_action_just_pressed("camera_in"):
			camera.fov = clamp(camera.fov + zoom_sensitivity, min_fov, max_fov)
			
		if Input.is_action_just_pressed("camera_out"):
			camera.fov = clamp(camera.fov - zoom_sensitivity, min_fov, max_fov)
