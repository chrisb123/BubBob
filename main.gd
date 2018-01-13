extends Node

export (PackedScene) var Title
#export (PackedScene) var Level1
#Level assigining needs fixing
#export (PackedScene) var Level2
export (PackedScene) var Player
export (PackedScene) var GUI
export (PackedScene) var Bubble
export (PackedScene) var Enemy
export (PackedScene) var PowerUp
export (PackedScene) var GameOver
export (PackedScene) var File_Main


var title
var player
var gui
var level
var gameover
var file_main
var score = 0
var max_enemies = 10
var leveln = 0
const MAX_LEVEL = 3
const SCORE_TO_LEVEL = 10

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	Global_Vars.score = 0
	Global_Vars.lives = Global_Vars.start_lives
	title = Title.instance()
	add_child(title)
	title.connect("start",self,"_start")
	#var level1 = Level1.instance()
	#add_child(level1)
	#var player = Player.instance()
	#add_child(player)
	#var gui = GUI.instance()
	#add_child(gui)


func _process(delta):
	if Input.is_action_just_pressed("ui_music"):
		get_node("Music").playing = !get_node("Music").playing
	# If lives gets to zero, delete all enemies and player, restart
	if Global_Vars.lives == 0:
		clear_nodes()
		gui.queue_free()
		file_main = File_Main.instance()
		add_child(file_main)
		_gameover()
		remove_child(file_main)
		#_ready()
	if Global_Vars.score > (SCORE_TO_LEVEL * leveln) && leveln < MAX_LEVEL:
		clear_nodes()
		#Change, make start start a function to start a level
		leveln += 1
		#dynamically load next level
		var resource = load("res://levels/level"+str(leveln)+".tscn")
		level = resource.instance()
		add_child(level)
		move_child(level,0)
		player = Player.instance()
		player.position = Vector2(140,180)
		add_child(player)
		player.connect("fired",self,"_fired")
		$Enemy.start()
	if Global_Vars.score > (SCORE_TO_LEVEL * leveln) && leveln == MAX_LEVEL:
		print("fdsfa")
		clear_nodes()
		#Should be GUI not Control
		$GUI_Layer/Control.queue_free()
		#Clear power up node
		_ready()

func clear_nodes():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.queue_free()
	var bubbles = get_tree().get_nodes_in_group("bubble")
	for bubble in bubbles:
		bubble.queue_free()
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.queue_free()
	var powerups = get_tree().get_nodes_in_group("powerup")
	for powerup in powerups:
		powerup.queue_free()
	$Enemy.stop()
	level.queue_free()
	#Global_Vars.score = 0


#parse level to "start"
func _start():
	#change to is title exists then remove
	remove_child(title)
	leveln = 1
	var resource = load("res://levels/level1.tscn")
	level = resource.instance()
	add_child(level)
	player = Player.instance()
	player.position = Vector2(140,180)
	add_child(player)
	player.connect("fired",self,"_fired")
	gui = GUI.instance()
	$GUI_Layer.add_child(gui)
	#not final location for Powerup Spawn, only testing here
	var powerup = PowerUp.instance()
	powerup.position = Vector2(600,100)
	add_child(powerup)
	$Enemy.start()
	
	
func _fired(facing):
	#print("fired ",facing)
	var bubble = Bubble.instance()
	bubble.facing = facing
	add_child(bubble)
	var pos = player.position
	pos.x += 33 * facing
	pos.y -= 5
	bubble.position = pos
	var anim = bubble.find_node("AnimatedSprite")
	#anim.connect("animation_finished",self,"popped")
	
#func popped():
	#score += 1
	#gui.get_child(0).text = str(score)

func do_nothing():
	pass

func _on_Enemy_timeout():
	var enemy_count = get_tree().get_nodes_in_group("enemy").size()
	if enemy_count < max_enemies:
		randomize()
		var mag = 0
		var epos = Vector2()
		while mag < 150:
			epos.x = randi()%1180+50
			epos.y = randi()%600+50
			var ab = epos - player.position
			mag = sqrt(ab.x*ab.x+ab.y*ab.y)
		var enemy = Enemy.instance()
		enemy.position = Vector2(epos.x,epos.y)
		add_child(enemy)
		#remove_child(enemy)
		
func _gameover():
	gameover = GameOver.instance()
	add_child(gameover)

	#Global_Vars.lives = 50