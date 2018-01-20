extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const start_lives = 2

var score = 0
var lives = start_lives
var leveln = 0

#Enemy spawning
#Enter enemy type to spawn 1, 2 or 3. 0 indicates no spawn for current cycle
#No limit on number of enemies to spawn.
#probably change to 3 waves inside each level to cut down on level design.

var Level0Enemies = [0]	# for title screens etc. to ensure nothing spawns at wrong time.
var Level1Enemies = [1,1,1,1,1,3,3,1,1,2]
var Level2Enemies = [1,1,3,1,1,3,3,1,1,2]
var Level3Enemies = [3,3,2,2,3,1,1,3,3,2]

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
