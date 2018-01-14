extends Control

signal start

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (PackedScene) var File_Main


func _ready():

	var file_main = File_Main.instance()
	add_child(file_main)
		
	var array = file_main.array 
	
	for i in range(clamp(array.size(),0,10)):
		$VBoxContainer/HighScore.text += (str(array[i], "\n"))

	remove_child(file_main)

func _on_Start_pressed():
	get_parent()._ready()
	queue_free()
	
func _on_Quit_pressed():
	get_tree().quit()
