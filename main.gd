extends Node

export (PackedScene) var Title
export (PackedScene) var Credits
export (PackedScene) var CIMAD
export (PackedScene) var Loading_Screen
#export (PackedScene) var Level1
#Level assigining needs fixing
#export (PackedScene) var Level2
export (PackedScene) var Player
export (PackedScene) var GUI
export (PackedScene) var Bubble
export (PackedScene) var Enemy
export (PackedScene) var Enemy2
export (PackedScene) var Enemy3
export (PackedScene) var EnemyBoss1
export (PackedScene) var EnemyBoss2
export (PackedScene) var EnemyBoss3
export (PackedScene) var PowerUp
export (PackedScene) var GameOver
export (PackedScene) var File_Main

#Advertising
export (PackedScene) var AdMob

#Debugging
export (PackedScene) var Debug

var title
var credits
var player
var enemy
var gui
var level
var gameover
var file_main
var score = 0
var max_enemies = 10
var levsize
const SCORE_TO_LEVEL = 10
var Enemy_Spawn

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	Global_Vars.score = 0
	Global_Vars.lives = Global_Vars.start_lives
	Global_Vars.enemyn = 0
	Global_Vars.waven = 0
	Global_Vars.leveln = 0
	Global_Vars.Osys = OS.get_name()

	#Instance Debug Overlay if in Debug
	if OS.is_debug_build():
		var debug = Debug.instance()
		add_child(debug)
		get_node("/root/Main/Debug")._String("Debug Mode")
	
	#Instance AdMob if available
	if OS.is_debug_build():
		get_node("/root/Main/Debug")._String("AdMob Initializing")
	if(Engine.has_singleton("AdMob")):
		if OS.is_debug_build():
			get_node("/root/Main/Debug")._String("AdMob Singleton OK")
		var admob = AdMob.instance()
		add_child(admob)
		admob._initialize(!OS.is_debug_build())	#CAREFUL, TRUE = real ads delivered
		if OS.is_debug_build():
			get_node("/root/Main/Debug")._String("AdMob Initialized OK")
	else:
		if OS.is_debug_build():
			get_node("/root/Main/Debug")._String("AdMob Singleton NOK")

	#CIMAD spalsh screen + Allow time for Admob to load ads.

	var CIMAD_splash = CIMAD.instance()
	add_child(CIMAD_splash)
	if OS.is_debug_build():
		yield(get_tree().create_timer(1),"timeout")
	else:
		yield(get_tree().create_timer(5),"timeout")		
	remove_child(CIMAD_splash)
	_title()


func _input(event):
	if event.is_action_pressed("ui_music"):
		get_node("Music").playing = !get_node("Music").playing
		get_node("/root/Main/Debug")._String("Toggle music")

#func _process(delta):
#	if Input.is_action_just_pressed("ui_music"):
#		get_node("Music").playing = !get_node("Music").playing
	# If lives gets to zero, or game is completed, delete all enemies and player, restart
#	if Global_Vars.gameover == true or ( Global_Vars.waven > Global_Vars.MAX_WAVES and Global_Vars.leveln == Global_Vars.MAX_LEVELS ):
#		#if Global_Vars.lives != 999:
#		gui.queue_free()
#		clear_nodes()
#		_gameover()
#		#cant stay at 0 during gameover screen, otherwise godot crashes
#	#	Global_Vars.lives = 999 #
#		Global_Vars.gameover = false
#		return
		#_ready()
		
		# change to "if waven > Global_Vars.MAX_WAVES:" (Should spawn all availble waves then change levels)
	#if Global_Vars.waven > Global_Vars.MAX_WAVES && Global_Vars.leveln == Global_Vars.MAX_LEVELS:
	#if Global_Vars.score > (SCORE_TO_LEVEL * leveln) && leveln == Global_Vars.MAX_LEVEL:
		#print("fdsfa")
		#clear_nodes()
		#Should be GUI not Control
		#$GUI_Layer/Control.queue_free()
		#Clear power up node
		#_ready()
#	if Global_Vars.waven > Global_Vars.MAX_WAVES:
#	#if Global_Vars.score > (SCORE_TO_LEVEL * leveln) && leveln < Global_Vars.MAX_LEVEL:
#		clear_nodes()
#		#Change, make start start a function to start a level
#		Global_Vars.leveln += 1
#
#		#dynamically load next level
#		_load_level()
		#var resource = load("res://levels/level"+str(Global_Vars.leveln)+".tscn")
		#level = resource.instance()
		#add_child(level)
		#move_child(level,0)
		#levsize = level.find_node("Size").size()
		#Enemy_Spawn = level.waves()
		#Global_Vars.MAX_WAVES = Enemy_Spawn.size() - 1
		#print(Enemy_Spawn)
#		print(Global_Vars.MAX_WAVES)
#		player = Player.instance()
#		player.position = Vector2(0,0)
#		add_child(player)
#		player.connect("fired",self,"_fired")
#		$Enemy.start()

		
		# calculate move to next wave ( Wave spawn Array empty and all Enemies dead )
#	if Global_Vars.leveln != 0 && Global_Vars.waven != 0:
#		for i in range (Enemy_Spawn[Global_Vars.waven].size()):
#			#print(Global_Vars.enemyn, "   " , Global_Vars.Enemy_Spawn[Global_Vars.leveln][Global_Vars.waven], "   ", Global_Vars.Enemy_Spawn[leveln][waven].size(), i,   Global_Vars.waven)
#			if Enemy_Spawn[Global_Vars.waven][i] == 999:
#				if i == (Enemy_Spawn[Global_Vars.waven].size() - 1) && Global_Vars.enemyn == 0:
#					Global_Vars.waven += 1
#					print("increasing wave number ",Global_Vars.waven)
#				i += i
			
func _load_level():
	
	#step 1:- Show Loading Screen, Interstital Available determines loading screen time
	var Loading = Loading_Screen.instance()
	add_child(Loading)
	
	#Step 2:- Show Interstital ADs if available
	if(Engine.has_singleton("AdMob")):
		if get_node("/root/Main/AdMob").inter_ready:
			yield(get_tree().create_timer(1),"timeout")
			get_node("/root/Main/AdMob")._show_interstital()
			yield(get_node("/root/Main/AdMob"),"LoadScreen_Finished") #emitted when ad closed
		else:
			get_node("/root/Main/AdMob").loadInterstitial() #try reloading interstital for next LVL change
			yield(get_tree().create_timer(5),"timeout") #Fake loading time, avoids turning off network to skip ads

	#Step 3:- Remove Loading Screen after Ad closed, or no ad shown
	remove_child(Loading)
		
	Global_Vars.waven = 1
	print("loading level ",Global_Vars.leveln)
	var resource = load("res://levels/level"+str(Global_Vars.leveln)+".tscn")
	level = resource.instance()
	add_child(level)
	move_child(level,0)
	levsize = level.find_node("Size").size()
	Enemy_Spawn = level.waves()
	Global_Vars.MAX_WAVES = Enemy_Spawn.size() - 1
	print("Enemy array ", Enemy_Spawn)
	print("Waves in level ",Global_Vars.MAX_WAVES)
	player = Player.instance()
	player.position = Vector2(0,0)
	add_child(player)
	player.connect("fired",self,"_fired")
	$Enemy.start()

func _title():
	#Show title screen
	if self.has_node("Credits"):
		remove_child(credits)
	title = Title.instance()
	add_child(title)
	title.connect("start",self,"_start")
	title.connect("credits",self,"_credits")	

func _credits():
	remove_child(title)
	credits = Credits.instance()
	add_child(credits)
	credits.connect("quit_credits",self,"_title")

#parse level to "start"
func _start():
	#change to is title exists then remove
	remove_child(title)
	if(Engine.has_singleton("AdMob")):
		get_node("/root/Main/AdMob")._hide_banner()
	Global_Vars.leveln = 1
	Global_Vars.waven = 1
	_load_level()
#	var resource = load("res://levels/level1.tscn")
#	level = resource.instance()
#	add_child(level)
#	levsize = level.find_node("Size").size()
#	Enemy_Spawn = level.waves()
#	print(Enemy_Spawn)
#	player = Player.instance()
#	player.position = Vector2(0,0)
#	add_child(player)
#	player.connect("fired",self,"_fired")
#	$Enemy.start()
	
	gui = GUI.instance()
	$GUI_Layer.add_child(gui)
	#not final location for Powerup Spawn, only testing here
	#var powerup = PowerUp.instance()
	#powerup.position = Vector2(600,100)
	#add_child(powerup)

	

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
	if enemy_count < max_enemies and Global_Vars.gameover == false:
		randomize()
		var mag = 0
		var epos = Vector2()
		while mag < 150:
			var i = 0
			#dont create enemies on tile map
			while i >= 0:
				epos.x = randi()%int(levsize[0])+int(levsize[1])
				epos.y = randi()%int(levsize[2])+int(levsize[3])
				i = level.get_cellv(level.world_to_map(Vector2(epos))) 
			var ab = epos - player.position
			mag = sqrt(ab.x*ab.x+ab.y*ab.y)

		#randomize new enemy type
		randomize()
		#Enemy spawn is defined in Global_Vars in as array

		#print ("wave # ",Global_Vars.waven)
		var EnemyArray = Enemy_Spawn[Global_Vars.waven]

		var i = 0
		for i in range (EnemyArray.size()):
			if EnemyArray[i] != 999:	#999 = already completed spawn
				if EnemyArray[i] == 0:	#Empty spawn cycle
					EnemyArray[i] = 999
					return
				elif EnemyArray[i] == 1:	#Enemy
					enemy = Enemy.instance()
					enemy.enemy_type = 1 #set enemy_type
				elif EnemyArray[i] == 2:	#Enemy2
					enemy = Enemy.instance()
					enemy.enemy_type = 2
				elif EnemyArray[i] == 3:	#Enemy3
					enemy = Enemy.instance()
					enemy.enemy_type = 3
				elif EnemyArray[i] == 101:	#EnemyBoss1
					enemy = EnemyBoss1.instance()
					enemy.boss_type = 1 #set boss_type
				elif EnemyArray[i] == 102:	#EnemyBoss2
					enemy = EnemyBoss1.instance()
					enemy.boss_type = 2
				elif EnemyArray[i] == 103:	#EnemyBoss3
					enemy = EnemyBoss1.instance()
					enemy.boss_type = 3
				elif EnemyArray[i] == 201:	#Powerup, no enemy +1 count
					enemy = PowerUp.instance()
					
				elif EnemyArray[i] == 998: #wait till all enemies destroyed
					if Global_Vars.enemyn == 0:
						EnemyArray[i] = 999
						return		#No enemy coutn increase
					else:
						return		# No enemy count increase
						
				if EnemyArray[i] < 200 || EnemyArray[i] > 299: #200 range reserved for powerups. No count up
					Global_Vars.enemyn += 1		#increase enemy count
					
				EnemyArray[i] = 999				#Clear Entry
				enemy.position = Vector2(epos.x,epos.y)
				add_child(enemy)
				return
			else:
				pass
			i += 1
	if Global_Vars.leveln != 0 && Global_Vars.waven != 0:
		for i in range (Enemy_Spawn[Global_Vars.waven].size()):
			#print(Global_Vars.enemyn, "   " , Global_Vars.Enemy_Spawn[Global_Vars.leveln][Global_Vars.waven], "   ", Global_Vars.Enemy_Spawn[leveln][waven].size(), i,   Global_Vars.waven)
			if Enemy_Spawn[Global_Vars.waven][i] == 999 && i == (Enemy_Spawn[Global_Vars.waven].size() - 1) && Global_Vars.enemyn == 0:
				Global_Vars.waven += 1
			i += i
	
	if Global_Vars.gameover == true or ( Global_Vars.waven > Global_Vars.MAX_WAVES and Global_Vars.leveln == Global_Vars.MAX_LEVELS ):
		gui.queue_free()
		clear_nodes()
		_gameover()
		Global_Vars.gameover = false
		return
	
	if Global_Vars.waven > Global_Vars.MAX_WAVES:
		clear_nodes()
		Global_Vars.leveln += 1
		_load_level()
		
func _gameover():
	gameover = GameOver.instance()
	add_child(gameover)

	#Global_Vars.lives = 50