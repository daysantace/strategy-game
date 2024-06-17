# camera.gd
# Camera pan and zoom

# Copyleft (c) 2024 daysant - STRUGGLE & STARS
# This file is licensed under the terms of the Affero GPL v3.0-or-later.
# daysant@proton.me

extends Node3D

var base_rotation_sensitivity = 0.1
var zoom_sensitivity = 1.0
var min_fov = 3.0
var max_fov = 90.0
var previous_mouse_position: Vector2
var pitch = 0.0
var yaw = 0.0
var target_pitch = 0.0
var target_yaw = 0.0
var target_fov = 70.0
var rotation_smoothness = 10.0
var zoom_smoothness = 5.0
var tilt_angle = 30.0
var tilt_start_fov = 10.0

@onready var camera = $Camera

func _ready():
	previous_mouse_position = get_viewport().get_mouse_position()
	set_process_input(true)
	target_fov = camera.fov

func _input(event: InputEvent):
	if Input.is_action_pressed("camera_pan"):
		if event is InputEventMouseMotion:
			var mouse_delta: Vector2 = event.relative
			var current_rotation_sensitivity = base_rotation_sensitivity * (camera.fov / max_fov)
			target_yaw -= mouse_delta.x * current_rotation_sensitivity
			target_pitch -= mouse_delta.y * current_rotation_sensitivity
			target_pitch = clamp(target_pitch, -89, 89)
	else:
		previous_mouse_position = get_viewport().get_mouse_position()

	if Input.is_action_just_pressed("camera_in"):
		target_fov = clamp(target_fov + zoom_sensitivity, min_fov, max_fov)
	if Input.is_action_just_pressed("camera_out"):
		target_fov = clamp(target_fov - zoom_sensitivity, min_fov, max_fov)

func _process(delta):
	yaw = lerp(yaw, target_yaw, delta * rotation_smoothness)
	pitch = lerp(pitch, target_pitch, delta * rotation_smoothness)

	var tilt = 0.0
	if camera.fov < tilt_start_fov:
		var tilt_factor = (tilt_start_fov - camera.fov) / (tilt_start_fov - min_fov)
		tilt = tilt_angle * tilt_factor
	
	rotation_degrees.y = yaw
	rotation_degrees.x = pitch + (tilt*0.65)
	rotation_degrees.z = 0
	
	camera.look_at(Vector3(0,0 + tilt,0))
	camera.fov = lerp(camera.fov, target_fov, delta * zoom_smoothness)