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
	var levelwave1 = [2,2,3,3,3,1,1,3,3,2,2,2,2]
	var levelwave2 = [0]#[2,2,2,2,3,3,3,3,2,2,2,2]
	var levelwave3 = [101,998,103,998,102]
	var debugwave1 = [2,1,3]
	var debugwave2 = [0]
	var debugwave3 = [101,998]
	
	if OS.is_debug_build():
		return [0, debugwave1, debugwave2, debugwave3]
	else:
		return [0, levelwave1, levelwave2, levelwave3]