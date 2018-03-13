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
var Osys
enum {ARENA,PUZZLE,STORY}
var gameMode = 0


var Difficulty = normal
const easy = 0.7
const normal = 1
const hard = 1.3
const insane = 2
	#factor based set in main menu

var enemyn = 0

#Scores for enemy kills

var score_enemy1 = 5
var score_enemy2 = 30
var score_enemy3 = 15
var score_enemyboss1 = 100
var score_enemyboss2 = 200
var score_enemyboss3 = 300
var score_death = -50

#Enemy spawning
#Set Maximum levels and maximum waves
#copy and paste level structure as bep
#anything larger than MAX_LEVELS AND MAX_WAVES is ignored in MAIN
#add all waves to levelX array
#add all levels to Enemy_Spawn array
#waves change tested, level change tested, End game NOT tested.

#0 = nothing this spawn cycle
#998 = wait till all all enemies detroyed before continuing

const MAX_LEVELS = 5
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

-------------------- TODO Before Release ----------------------------

- (DONE, just using NewBubble.png ) new App Icon
- (DONE) Music on/off button main menu
- (DONE) Intro instructions for PC or Android
- (DONE. Explaned in Intro Screen) Joypad button needs to be more obvious or better explained
- (DONE. Only hidden) remove lives from GUI

- see if you like joypad, may need to adjust angles were it changes player direction ?? (changed)
- Powerups have/need timeout ?? (no spam the crap out of it)
- change CIMAD "we have no idea what we're doing" ?? (to what?)

I think thats enough unless you can think of something else.



 --------------------  IDEAS --------------------------------

- (DONE) quit button for android while playing
- (DONE) Zoom & Music button implemented for android 
- (DONE) implement Advertising (Splash screen before level start, or constant banner while playing)
- balance monster waves
- (DONE) Change lives to unlimited but reduce score 
- Change poping bubble combos and emey to a higher score
- (DONE) Change enemy score to be higher
- (Done) Replace the packed scenes

----------------------- ToDO ----------------------------------

 - (Intial done) CIMAD spalsh screen before title screen
 - (Initial done) Loading screen for 1s before showing intertital ads (admob requirment)
 - add other uncoded buttons for future use, such as?

 - Asset citation screen (licence requirments)
	- Background      CC by 3.0 - Alekei - https://opengameart.org/content/background-night
	- Monsters        CC by 3.0 - Redshrike - https://opengameart.org/content/3-rpg-enemy-remixes
	- Music	          CC by 3.0 - Zander Noriega - https://opengameart.org/content/darker-waves
	- Coin            CC by 3.0 - JM.Atencia - https://opengameart.org/content/spinning-coin
	
	All game art sourced from https://opengameart.org/
	CC by 3.0 licence link - https://creativecommons.org/licenses/by/3.0/

- Public Domain Assests
	- SFX Bubble pop	Public DOmain CCO
	- Explosion			Public Domain CCO
	- Tilemap			Public Domain CCO
	- Fireball			Public Domain CCO
	- new bubble		Public Domain CCO
	- Angry Kid			Public Domain CCO
	- Potions			Public Domain CCO
	- Drink SFX			Public Domain CCO
----------------------- NOTES ----------------------------------

- I did some multitouch tests on android, godot connects touch idx and drag idx
even with multiple fingers touching at same time
- joypad is centred around X "button"
- small deadspace just around the X, joypad has range of about 150 pixels
- Joypad position currently fixed, will make dynamic later, if better than buttons.
- Dont use export (PackedScene) var Player
	Instead declare the resource dynamicallly or statically
	var resource = load("res://levels/level"+str(Global_Vars.leveln)+".tscn")

---------------------- BUGS ----------------------------------


--------------- ADRIAN CURRENT TASKS -------------------------

 - (DONE) More Power Ups
 - (DONE) AdMob Installation
 - (DONE) Debug Overlay
 - Bug with file on the highscores screen

 -------------- CHRIS CURRENT TASKS ---------------------------

 --------------------------------------------------------------
"""