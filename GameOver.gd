extends Control

signal start

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var array = get_parent().get_node("File_Main").array
	
	for i in range(clamp(array.size(),0,10)):
		$VBoxContainer/HighScore.text += (str(array[i], " "))
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Start_pressed():
	emit_signal("start")

func _on_Quit_pressed():
	get_tree().quit()
