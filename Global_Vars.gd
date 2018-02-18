extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const start_lives = 0
var gameover = false #add gameover ability
var score = 0
var lives = start_lives
var leveln = 0
var waven = 0

var enemyn = 0

#Scores for enemy kills

var	score_enemy1 = 5
var score_enemy2 = 10
var score_enemy3 = 30
var score_enemyboss1 = 100
var score_enemyboss2 = 200
var score_enemyboss3 = 300
var score_death = -20

#Enemy spawning
#Set Maximum levels and maximum waves
#copy and paste level structure as bep
#anything larger than MAX_LEVELS AND MAX_WAVES is ignored in MAIN
#add all waves to levelX array
#add all levels to Enemy_Spawn array
#waves change tested, level change tested, End game NOT tested.

#0 = nothing this spawn cycle
#998 = wait till all all enemies detroyed before continuing

const MAX_LEVELS = 4
var  MAX_WAVES = 0

#var Level0Enemies = [0]	# for title screens etc. to ensure nothing spawns at wrong time.

# level 1 wave structure
#var level1wave1 = [101,998,3,2,1,2,1,1,998,101]
#var level1wave2 = [1,1,3,3,1,1,1,3,3,1]
#var level1wave3 = [3,3,1,1,2,1,1,3,3,1]
#var level1 = [0, level1wave1, level1wave2, level1wave3]
#
## level 2 wave structure
#var level2wave1 = [2,2,1]
#var level2wave2 = [3,3,1]
#var level2wave3 = [1,1,1]
#var level2 = [0, level2wave1, level2wave2, level2wave3]
#
#var Enemy_Spawn = [0, level1, level2]


func _ready():
	#print (Enemy_Spawn[2][2][1])
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	#print(enemyn, waven, leveln)
	pass


"""
-------------------------------------------------------------
TO DO LIST  -  add ideas, task etc here
-------------------------------------------------------------

 --------------------  IDEAS --------------------------------

- quit button for android while playing
- Zoom & Music button implemented for android 
- implement Advertising (Splash screen before level start, or constant banner while playing)
- balance monster waves
- Change lives to unlimited but reduce score
- Change poping bubble combos and emey to a higher score
- Change enemy score to be higher

----------------------- ToDO ----------------------------------

 - (Intial done) CIMAD spalsh screen before title screen
 - (Initial done) Loading screen for 1s before showing intertital ads (admob requirment)
 - add killall button to debug screen (add other uncoded buttons for future use)

 - Asset citation screen (licence requirments)
	- Background		Alekei - OpenGameArt.org/users/alekei
	- Angry Kid			Public Domain CCO - http://bevouliin.com
	- Monsters			Stephen Challener (Redshrike) - www.angry-turtle.com  (maybe look for animated ones)
	- Fireball			Public Domain CCO - No citaction required no webpage
	- Bubble			Wolfgang Wozniak - http://wolfgame.com/
		- new bubble	Alok Narula - http://fb.com/aloknarula
	- Music				Zander Noriega - https://soundcloud.com/zander-noriega
	- SFX Bubble pop	Public DOmain CCO - Fabien - https://twitter.com/farfadet46
	- Explosion			@Chris, can you find this one out. i cant find it (maybe look for a better one)
	- Tilemap			@Chris, can you find this one out. i cant find it
	- 

----------------------- NOTES ----------------------------------

- I did some multitouch tests on android, godot connects touch idx and drag idx
even with multiple fingers touching at same time
- joypad is centred around X "button"
- small deadspace just around the X, joypad has range of about 150 pixels
- Joypad position currently fixed, will make dynamic later, if better than buttons.

---------------------- BUGS ----------------------------------


--------------- ADRIAN CURRENT TASKS -------------------------

 - More Power Ups
 - AdMob Installation
 - Debug Overlay

 -------------- CHRIS CURRENT TASKS ---------------------------

 --------------------------------------------------------------
"""