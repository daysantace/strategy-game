extends Node

var logging_detail = 3

func info(text):
	if logging_detail>2:
		print_rich("[color=#ffffff]INFO  | ",text)

func debug(text):
	if logging_detail>1:
		print_rich("[color=#8888ff]DEBUG | ",text)
	
func warn(text):
	if logging_detail>0:
		print_rich("[color=#ffff88]WARN  | ",text)
	
func error(text):
	print_rich("[color=#ff8888]ERROR | ",text)
