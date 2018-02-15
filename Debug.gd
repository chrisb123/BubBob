extends Node


# String 1 - 10 Monitoring variables
# String 11 - 20 String push stack

var StrOffsetY = 20

func _ready():
	$CanvasLayer/FPS.margin_top = 70
	$CanvasLayer/FPS.margin_bottom = 110
	$CanvasLayer/FPS.margin_left = 10
	$CanvasLayer/FPS.margin_right = 400

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

	$CanvasLayer/str9.margin_top = ($CanvasLayer/str8.margin_top + StrOffsetY)
	$CanvasLayer/str9.margin_bottom = ($CanvasLayer/str8.margin_bottom + StrOffsetY)
	$CanvasLayer/str9.margin_left = 10
	$CanvasLayer/str9.margin_right = 400

	$CanvasLayer/str10.margin_top = ($CanvasLayer/str9.margin_top + StrOffsetY)
	$CanvasLayer/str10.margin_bottom = ($CanvasLayer/str9.margin_bottom + StrOffsetY)
	$CanvasLayer/str10.margin_left = 10
	$CanvasLayer/str10.margin_right = 400

	#Empty Space

	$CanvasLayer/str11.margin_top = ($CanvasLayer/str10.margin_top + (2 * StrOffsetY))
	$CanvasLayer/str11.margin_bottom = ($CanvasLayer/str10.margin_bottom + (2 * StrOffsetY))
	$CanvasLayer/str11.margin_left = 10
	$CanvasLayer/str11.margin_right = 400

	$CanvasLayer/str12.margin_top = ($CanvasLayer/str11.margin_top + StrOffsetY)
	$CanvasLayer/str12.margin_bottom = ($CanvasLayer/str11.margin_bottom + StrOffsetY)
	$CanvasLayer/str12.margin_left = 10
	$CanvasLayer/str12.margin_right = 400

	$CanvasLayer/str13.margin_top = ($CanvasLayer/str12.margin_top + StrOffsetY)
	$CanvasLayer/str13.margin_bottom = ($CanvasLayer/str12.margin_bottom + StrOffsetY)
	$CanvasLayer/str13.margin_left = 10
	$CanvasLayer/str13.margin_right = 400

	$CanvasLayer/str14.margin_top = ($CanvasLayer/str13.margin_top + StrOffsetY)
	$CanvasLayer/str14.margin_bottom = ($CanvasLayer/str13.margin_bottom + StrOffsetY)
	$CanvasLayer/str14.margin_left = 10
	$CanvasLayer/str14.margin_right = 400

	$CanvasLayer/str15.margin_top = ($CanvasLayer/str14.margin_top + StrOffsetY)
	$CanvasLayer/str15.margin_bottom = ($CanvasLayer/str14.margin_bottom + StrOffsetY)
	$CanvasLayer/str15.margin_left = 10
	$CanvasLayer/str15.margin_right = 400

	$CanvasLayer/str16.margin_top = ($CanvasLayer/str15.margin_top + StrOffsetY)
	$CanvasLayer/str16.margin_bottom = ($CanvasLayer/str15.margin_bottom + StrOffsetY)
	$CanvasLayer/str16.margin_left = 10
	$CanvasLayer/str16.margin_right = 400

	$CanvasLayer/str17.margin_top = ($CanvasLayer/str16.margin_top + StrOffsetY)
	$CanvasLayer/str17.margin_bottom = ($CanvasLayer/str16.margin_bottom + StrOffsetY)
	$CanvasLayer/str17.margin_left = 10
	$CanvasLayer/str17.margin_right = 400

	$CanvasLayer/str18.margin_top = ($CanvasLayer/str17.margin_top + StrOffsetY)
	$CanvasLayer/str18.margin_bottom = ($CanvasLayer/str17.margin_bottom + StrOffsetY)
	$CanvasLayer/str18.margin_left = 10
	$CanvasLayer/str18.margin_right = 400

	$CanvasLayer/str19.margin_top = ($CanvasLayer/str18.margin_top + StrOffsetY)
	$CanvasLayer/str19.margin_bottom = ($CanvasLayer/str18.margin_bottom + StrOffsetY)
	$CanvasLayer/str19.margin_left = 10
	$CanvasLayer/str19.margin_right = 400

	$CanvasLayer/str20.margin_top = ($CanvasLayer/str19.margin_top + StrOffsetY)
	$CanvasLayer/str20.margin_bottom = ($CanvasLayer/str19.margin_bottom + StrOffsetY)
	$CanvasLayer/str20.margin_left = 10
	$CanvasLayer/str20.margin_right = 400


func _String1(string):
	$CanvasLayer/str1.text = string
	
func _String2(string):
	$CanvasLayer/str2.text = string
	
func _String3(string):
	$CanvasLayer/str3.text = string

func _String4(string):
	$CanvasLayer/str4.text = string

func _String5(string):
	$CanvasLayer/str5.text = string

func _String6(string):
	$CanvasLayer/str6.text = string

func _String7(string):
	$CanvasLayer/str7.text = string

func _String8(string):
	$CanvasLayer/str8.text = string

func _String9(string):
	$CanvasLayer/str9.text = string

func _String10(string):
	$CanvasLayer/str10.text = string

func _String(string):
	$CanvasLayer/str19.text = $CanvasLayer/str18.text
	$CanvasLayer/str18.text = $CanvasLayer/str17.text
	$CanvasLayer/str17.text = $CanvasLayer/str16.text
	$CanvasLayer/str16.text = $CanvasLayer/str15.text
	$CanvasLayer/str15.text = $CanvasLayer/str14.text
	$CanvasLayer/str14.text = $CanvasLayer/str13.text
	$CanvasLayer/str13.text = $CanvasLayer/str12.text
	$CanvasLayer/str12.text = $CanvasLayer/str11.text
	$CanvasLayer/str11.text = string

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_FPS_Timer_timeout():
	$CanvasLayer/FPS.text = str("FPS ", Engine.get_frames_per_second())
	pass # replace with function body
