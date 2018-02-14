extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var DebugStr1 = ""
var DebugStr2 = ""
var DebugStr3 = ""
var DebugStr4 = ""
var DebugStr5 = ""
var DebugStr6 = ""
var DebugStr7 = ""
var DebugStr8 = ""
var DebugStr9 = ""

var StrOffsetY = 20

func _ready():
	$CanvasLayer/str1.text = DebugStr1
	$CanvasLayer/str2.text = DebugStr2
	$CanvasLayer/str3.text = DebugStr3
	$CanvasLayer/str4.text = DebugStr4
	$CanvasLayer/str5.text = DebugStr5
	$CanvasLayer/str6.text = DebugStr6
	$CanvasLayer/str7.text = DebugStr7
	$CanvasLayer/str8.text = DebugStr8
	$CanvasLayer/str9.text = DebugStr9
		
	$CanvasLayer/str1.margin_top = 100
	$CanvasLayer/str1.margin_bottom = 140
	$CanvasLayer/str1.margin_left = 10
	$CanvasLayer/str1.margin_right = 400
	
	$CanvasLayer/str2.margin_top = ($CanvasLayer/str1.margin_top + StrOffsetY)
	$CanvasLayer/str2.margin_bottom = ($CanvasLayer/str1.margin_bottom + StrOffsetY)
	$CanvasLayer/str2.margin_left = 10
	$CanvasLayer/str2.margin_right = 400
	
	$CanvasLayer/str3.margin_top = ($CanvasLayer/str2.margin_top + StrOffsetY)
	$CanvasLayer/str3.margin_bottom = ($CanvasLayer/str2.margin_bottom + StrOffsetY)
	$CanvasLayer/str3.margin_left = 10
	$CanvasLayer/str3.margin_right = 400

	$CanvasLayer/str4.margin_top = ($CanvasLayer/str3.margin_top + StrOffsetY)
	$CanvasLayer/str4.margin_bottom = ($CanvasLayer/str3.margin_bottom + StrOffsetY)
	$CanvasLayer/str4.margin_left = 10
	$CanvasLayer/str4.margin_right = 400

	$CanvasLayer/str5.margin_top = ($CanvasLayer/str4.margin_top + StrOffsetY)
	$CanvasLayer/str5.margin_bottom = ($CanvasLayer/str4.margin_bottom + StrOffsetY)
	$CanvasLayer/str5.margin_left = 10
	$CanvasLayer/str5.margin_right = 400

	$CanvasLayer/str6.margin_top = ($CanvasLayer/str5.margin_top + StrOffsetY)
	$CanvasLayer/str6.margin_bottom = ($CanvasLayer/str5.margin_bottom + StrOffsetY)
	$CanvasLayer/str6.margin_left = 10
	$CanvasLayer/str6.margin_right = 400

	$CanvasLayer/str7.margin_top = ($CanvasLayer/str6.margin_top + StrOffsetY)
	$CanvasLayer/str7.margin_bottom = ($CanvasLayer/str6.margin_bottom + StrOffsetY)
	$CanvasLayer/str7.margin_left = 10
	$CanvasLayer/str7.margin_right = 400

	$CanvasLayer/str8.margin_top = ($CanvasLayer/str7.margin_top + StrOffsetY)
	$CanvasLayer/str8.margin_bottom = ($CanvasLayer/str7.margin_bottom + StrOffsetY)
	$CanvasLayer/str8.margin_left = 10
	$CanvasLayer/str8.margin_right = 400

	$CanvasLayer/str9.margin_top = ($CanvasLayer/str8.margin_top + StrOffsetY)
	$CanvasLayer/str9.margin_bottom = ($CanvasLayer/str8.margin_bottom + StrOffsetY)
	$CanvasLayer/str9.margin_left = 10
	$CanvasLayer/str9.margin_right = 400

func _String1(string):
	$CanvasLayer/str1.text = string
	
func _String2(string):
	$CanvasLayer/str2.text = string
	
func _String3(string):
	$CanvasLayer/str3.text = string


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
