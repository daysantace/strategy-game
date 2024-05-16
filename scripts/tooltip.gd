extends Node2D

func _process(_delta):
	if global.mouse_over_province:
		visible = true
	else:
		visible = false
		
	position = get_viewport().get_mouse_position()
	$province_name.text = global.tooltip_text_province
