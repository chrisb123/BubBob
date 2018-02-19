extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

signal quit_credits

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Button_pressed():
	emit_signal("quit_credits")
	pass # replace with function body
