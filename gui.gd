extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var score = get_node("Score")
onready var lives = get_node("Lives")
onready var level = get_node("Level")
var leveln_backup = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	score.text = str("Score: " + str(Global_Vars.score))
	lives.text = str("Lives: " + str(Global_Vars.lives))
	level.text = str("Level " + str(Global_Vars.leveln))
	
	if Global_Vars.leveln != leveln_backup:
		leveln_backup = Global_Vars.leveln
		level.visible = true
		$Level/Level_Change.interpolate_property($Level, 'rect_scale', $Level.get_scale(), Vector2(3,3) , 2, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$Level/Level_Change.start()
		

func _on_Level_Change_tween_completed( object, key ):
	level.visible = false