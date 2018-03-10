extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process_input(true)
#	pass

func _input():
	print("test")
	if InputEventScreenTouch.pressed:
		print("pressed")
