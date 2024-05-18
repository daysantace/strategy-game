extends Node2D

var claimants

func _process(_delta):
	await get_tree().create_timer(0.001).timeout
		
	if not global.selected_province_name:
		$province_name.text = "No province selected"
	else:
		$province_name.text = str(global.selected_province_name)+"\nOwned by "+str(global.selected_country_name)
