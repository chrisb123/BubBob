extends Control

signal start
signal credits

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	if OS.has_touchscreen_ui_hint():
		$VBoxContainer/Info_Other.visible = false
		$VBoxContainer/Info_Android.visible = true
	else:
		$VBoxContainer/Info_Other.visible = true
		$VBoxContainer/Info_Android.visible = false
		
		

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Start_pressed():
	emit_signal("start")

func _on_Quit_pressed():
	get_tree().quit()


func _on_Credits_pressed():
	emit_signal("credits")
	pass # replace with function body


func _on_Button_pressed():
	get_parent().get_node("Music").playing = !get_parent().get_node("Music").playing
	pass # replace with function body
