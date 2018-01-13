extends Control

signal start

export (PackedScene) var File_Main

var writefile

func _ready():
	writefile = File_Main.instance()
	add_child(writefile)
	print(writefile)
	
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Start_pressed():
	emit_signal("start")

func _on_Quit_pressed():
	get_tree().quit()