extends Node

onready var camera = get_node("/root/Main/Player/AnimatedSprite/Camera2D")
onready var music = get_node("/root/Main/Music")

func _ready():
	if ! OS.is_debug_build():
		$VBoxContainer/KillAll.hide()
	get_tree().paused = true

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_ZoomIn_pressed():
	camera.zoomin()


func _on_Back_pressed():
	get_tree().paused = false
	queue_free()


func _on_Quit_pressed():
	get_tree().paused = false
	Global_Vars.gameover = true


func _on_ZoomOut_pressed():
	camera.zoomout()


func _on_Music_pressed():
	music.playing = !music.playing


func _on_KillAll_pressed():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for i in enemies:
		i.get_node("AnimatedSprite").play()
	get_tree().paused = false
	_on_Back_pressed()
