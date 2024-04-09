extends VBoxContainer

func _ready():
	pass

func _process(delta):
	pass
	
func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/map.tscn")
