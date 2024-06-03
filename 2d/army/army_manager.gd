extends Node

var selected_army = null

func create_army(province_location):
	var army = load("res://army/army.tscn").instantiate()
	army.location = province_location
	army.commander = GameManager.player
	add_child(army)

func _on_make_unit_pressed():
	if !($"../provinces".selected_province == null):
		if $"../provinces".selected_province.region_owner == GameManager.player:
			create_army($"../provinces".selected_province)
		else:
			pass
	else:
		pass
