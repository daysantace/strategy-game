extends Node

func _ready():
	var random = RandomNumberGenerator.new()
	$num.text = str(random.randi_range(1,99))
