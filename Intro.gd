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
	Global_Vars.Difficulty == Global_Vars.easy
	_on_Difficulty_pressed()
	Global_Vars.gameMode = Global_Vars.PUZZLE
	_on_Mode_pressed()
		
#	if Global_Vars.Difficulty == Global_Vars.easy:
#		$VBoxContainer/HBox/Difficulty.text = "Difficulty: Easy"
#	elif Global_Vars.Difficulty == Global_Vars.normal:
#		$VBoxContainer/HBox/Difficulty.text = "Difficulty: Normal"
#	elif Global_Vars.Difficulty == Global_Vars.hard:
#		$VBoxContainer/HBox/Difficulty.text = "Difficulty: Hard"
#	elif Global_Vars.Difficulty == Global_Vars.insane:
#		$VBoxContainer/HBox/Difficulty.text = "Difficulty: Insane"
		
		

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


func _on_Music_pressed():
	get_parent().get_node("Music").playing = !get_parent().get_node("Music").playing
	pass # replace with function body


func _on_Difficulty_pressed():
	if Global_Vars.Difficulty == Global_Vars.easy:
		$VBoxContainer/HBox/Difficulty.text = "Difficulty: Normal"
		Global_Vars.Difficulty = Global_Vars.normal
	elif Global_Vars.Difficulty == Global_Vars.normal:
		$VBoxContainer/HBox/Difficulty.text = "Difficulty: Hard"
		Global_Vars.Difficulty = Global_Vars.hard
	elif Global_Vars.Difficulty == Global_Vars.hard:
		$VBoxContainer/HBox/Difficulty.text = "Difficulty: Insane"
		Global_Vars.Difficulty = Global_Vars.insane
	elif Global_Vars.Difficulty == Global_Vars.insane:
		$VBoxContainer/HBox/Difficulty.text = "Difficulty: Easy"
		Global_Vars.Difficulty = Global_Vars.easy
		


func _on_Mode_pressed():
	if Global_Vars.gameMode == Global_Vars.ARENA:
		$VBoxContainer/HBox/Mode.text = "Mode: Puzzle"
		Global_Vars.gameMode = Global_Vars.PUZZLE
	elif Global_Vars.gameMode == Global_Vars.PUZZLE:
		$VBoxContainer/HBox/Mode.text = "Mode: Arena"
		Global_Vars.gameMode = Global_Vars.ARENA