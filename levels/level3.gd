extends TileMap

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func waves():
	var level2wave1 = [2,2,1]
	var level2wave2 = [3,3,1]
	var level2wave3 = [1,1,1]
	return [0, level2wave1, level2wave2, level2wave3]