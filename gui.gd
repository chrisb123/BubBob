extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var score = get_node("Score")
onready var lives = get_node("Lives")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	score.text = str("Score: " + str(Global_Vars.score))
	lives.text = str("Lives: " + str(Global_Vars.lives))