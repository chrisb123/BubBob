extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const start_lives = 2

var score = 0
var lives = start_lives
var leveln = 0
var waven = 0

var enemyn = 0

#Enemy spawning
#Set Maximum levels and maximum waves
#copy and paste level structure as below
#anything larger than MAX_LEVELS AND MAX_WAVES is ignored in MAIN
#add all waves to levelX array
#add all levels to Enemy_Spawn array
#waves change tested, level change tested, End game NOT tested.

#0 = nothing this spawn cycle
#998 = wait till all all enemies detroyed before continuing

const MAX_LEVELS = 4
const MAX_WAVES = 3

var Level0Enemies = [0]	# for title screens etc. to ensure nothing spawns at wrong time.

# level 1 wave structure
var level1wave1 = [101,998,3,2,1,2,1,1,998,101]
var level1wave2 = [1,1,3,3,1,1,1,3,3,1]
var level1wave3 = [3,3,1,1,2,1,1,3,3,1]
var level1 = [0, level1wave1, level1wave2, level1wave3]

# level 2 wave structure
var level2wave1 = [2,2,1]
var level2wave2 = [3,3,1]
var level2wave3 = [1,1,1]
var level2 = [0, level2wave1, level2wave2, level2wave3]

var Enemy_Spawn = [0, level1, level2]


func _ready():
	#print (Enemy_Spawn[2][2][1])
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	print(enemyn)
#	pass
