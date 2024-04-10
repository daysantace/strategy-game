extends Camera2D

var acceleration = 0
var zoom_level = 0

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
		zoom_level-=0.05
	if Input.is_action_just_pressed("cam_out"):
		zoom_level+=0.05
	zoom_level=clamp(zoom_level,0.1,5)
	zoom=Vector2(zoom_level,zoom_level)
	
	position += ((pan_direction * (100+acceleration) * delta)/diag_fix)/zoom_level
