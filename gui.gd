extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var score = get_node("Score")
onready var lives = get_node("Lives")
onready var level = get_node("Level")
var leveln_backup = 0

func _ready():
	var xsize = (get_viewport().get_visible_rect().size.x)
	var ysize = (get_viewport().get_visible_rect().size.y)
	$Shoot.margin_right = xsize
	$Shoot.margin_bottom = ysize
	$Shoot.margin_left = xsize - xsize * 0.15
	$Shoot.margin_top = ysize - ysize * 0.15
	$Jump.margin_right = xsize
	$Jump.margin_bottom = ysize - ysize * 0.15
	$Jump.margin_left = xsize - xsize * 0.15
	$Jump.margin_top = ysize - ysize * 0.3
	$Left.margin_right = xsize * 0.15
	$Left.margin_bottom = ysize
	$Left.margin_left = 0
	$Left.margin_top = ysize - ysize * 0.15
	$Right.margin_right = xsize * 0.3
	$Right.margin_bottom = ysize
	$Right.margin_left = xsize * 0.15
	$Right.margin_top = ysize - ysize * 0.15
	
	$JoyPad.rect_position.x = 600
	$JoyPad.rect_position.y = 600
#	if ! OS.has_virtual_keyboard():
#		$Shoot.hide()
#		$Jump.hide()
#		$Left.hide()
#		$Right.hide()
	
	
func _process(delta):
	score.text = str("Score: " + str(Global_Vars.score))
	lives.text = str("Lives: " + str(Global_Vars.lives))
	level.text = str("Level " + str(Global_Vars.leveln))
	
	#if Global_Vars.leveln != leveln_backup:
	#	leveln_backup = Global_Vars.leveln
	#	level.visible = true
	#	$Level/Level_Change.interpolate_property($Level, 'rect_scale', $Level.get_scale(), Vector2(3,3) , 2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	#	$Level/Level_Change.start()
		

func _on_Level_Change_tween_completed( object, key ):
	level.visible = false
