extends Node

func _ready():
	pass

func create_army(province_location):
	var army = load("res://scenes/army.tscn").instantiate()
	army.location = province_location
	army.commander = GlobalVar.player
	add_child(army)
