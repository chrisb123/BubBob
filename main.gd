extends Node

var Title = load("res://Intro.tscn")
var Credits = load("res://Credits.tscn")
var CIMAD = load("res://CIMAD.tscn")
var Loading_Screen = load("res://Loading_Screen.tscn")
#export (PackedScene) var Level1
#Level assigining needs fixing
#export (PackedScene) var Level2
var Player = load("res://player.tscn")
var GUI = load("res://gui.tscn")
var Bubble = load("res://bubble1.tscn")
var Enemy = load("res://Enemy.tscn")
#export (PackedScene) var Enemy2
#export (PackedScene) var Enemy3
var EnemyBoss1 = load("res://EnemyBoss1.tscn")
#export (PackedScene) var EnemyBoss2
#export (PackedScene) var EnemyBoss3
var PowerUp = load("res://PowerUp.tscn")
var GameOver = load("res://GameOver.tscn")
var File_Main = load("res://File_Main.tscn")

#Advertising
var AdMob = load("res://AdMob.tscn")

#Debugging
var Debug = load("res://Debug.tscn")

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
var camera

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_tree().set_auto_accept_quit(false)
	
	Global_Vars.score = 0
	Global_Vars.lives = Global_Vars.start_lives #the point of this line?
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
		get_node("Music").playing = !get_node("Music").playing
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
		if OS.is_debug_build():
			get_node("/root/Main/Debug")._String("Toggle music")
			
func _load_level():
	if self.has_node("Player"):
		player.set_physics_process(false)
		player.visible = false
		camera.visible = false
		player.position = Vector2(640,360) #This is a terrible solution
	#step 1:- Show Loading Screen, Interstital Available determines loading screen time
	var Loading = Loading_Screen.instance()
	add_child(Loading) #why does this not load up in the center of the screen
	
	#Step 2:- Show Interstital ADs if available
	if(Engine.has_singleton("AdMob")):
		if get_node("/root/Main/AdMob").inter_ready:
			yield(get_tree().create_timer(1),"timeout")
			get_node("/root/Main/AdMob")._show_interstital()
			yield(get_node("/root/Main/AdMob"),"LoadScreen_Finished") #emitted when ad closed
		else:
			get_node("/root/Main/AdMob").loadInterstitial() #try reloading interstital for next LVL change
			yield(get_tree().create_timer(5),"timeout") #Fake loading time, avoids turning off network to skip ads
	else:
		yield(get_tree().create_timer(2),"timeout") #Load screen for no Admob
		
		
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
	if ! self.has_node("Player"):
		player = Player.instance()
		add_child(player)
		player.connect("fired",self,"_fired")
		camera = get_node("/root/Main/Player/AnimatedSprite/Camera2D")
	camera.current = true
	player.set_physics_process(true)
	player.visible = true
	player.position = Vector2(0,0)
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
	
	gui = GUI.instance()
	$GUI_Layer.add_child(gui)
	

func clear_nodes():
	$Enemy.stop()	
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.queue_free()
	var bubbles = get_tree().get_nodes_in_group("bubble")
	for bubble in bubbles:
		bubble.queue_free()
	var powerups = get_tree().get_nodes_in_group("powerup")
	for powerup in powerups:
		powerup.queue_free()
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

func find_spawn(dist, maxdist):
	var mag = 0
	if dist < 25:
		dist = 150
	if maxdist < (dist + 25):
		maxdist = dist + 9999
	var spos = Vector2()
	while mag < dist or mag > maxdist:
		var i = 0
		#dont create enemies on tile map
		while i >= 0:
			spos.x = randi()%int(levsize[0])+int(levsize[1])
			spos.y = randi()%int(levsize[2])+int(levsize[3])
			i = level.get_cellv(level.world_to_map(Vector2(spos))) 
		var ab = spos - player.position
		mag = sqrt(ab.x*ab.x+ab.y*ab.y)
	return spos

func _on_Enemy_timeout():
	#Add powerups randomly 10% chance
	if ! randi()%10:
		var powerpos = find_spawn(150,300)
		var powerups = PowerUp.instance()
		powerups.get_node("PowerUp").powerup_type = randi()%4+1
		powerups.get_node("PowerUp").position = Vector2(powerpos.x,powerpos.y)
		add_child(powerups)

	var enemy_count = get_tree().get_nodes_in_group("enemy").size()
	if enemy_count < max_enemies and Global_Vars.gameover == false:
		randomize()
		var epos = find_spawn(150,0)
		
		#randomize new enemy type
#		randomize()
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
					enemy.get_node("Enemy").enemy_type = 1 #set enemy_type
				elif EnemyArray[i] == 2:	#Enemy2
					enemy = Enemy.instance()
					enemy.get_node("Enemy").enemy_type = 2
				elif EnemyArray[i] == 3:	#Enemy3
					enemy = Enemy.instance()
					enemy.get_node("Enemy").enemy_type = 3
				elif EnemyArray[i] == 101:	#EnemyBoss1
					enemy = EnemyBoss1.instance()
					enemy.get_node("Enemy").boss_type = 1 #set boss_type
				elif EnemyArray[i] == 102:	#EnemyBoss2
					enemy = EnemyBoss1.instance()
					enemy.get_node("Enemy").boss_type = 2
				elif EnemyArray[i] == 103:	#EnemyBoss3
					enemy = EnemyBoss1.instance()
					enemy.get_node("Enemy").boss_type = 3
				elif EnemyArray[i] == 201:	#Powerup, no enemy +1 count
					enemy = PowerUp.instance()
					enemy.powerup_type = 1					
				elif EnemyArray[i] == 202:	#Powerup, no enemy +1 count
					enemy = PowerUp.instance()
					enemy.powerup_type = 2					
				elif EnemyArray[i] == 203:	#Powerup, no enemy +1 count
					enemy = PowerUp.instance()
					enemy.powerup_type = 3					
				elif EnemyArray[i] == 204:	#Powerup, no enemy +1 count
					enemy = PowerUp.instance()
					enemy.powerup_type = 4					
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
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.queue_free()
	
	#Duplicating code....
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
	
	gameover = GameOver.instance()
	add_child(gameover)

	#Global_Vars.lives = 50