extends Camera2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#func _ready():
#	# Called every time the node is added to the scene.
#	# Initialization here
#	pass

#func _process(delta):
#	if Input.is_action_just_pressed("ui_camzoom"):
#		if zoom < Vector2(2,2):
#			$Zoom.interpolate_property(self, 'zoom', self.zoom, self.zoom + Vector2(0.25,0.25) , 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
#			$Zoom.start()
#		else:
#			$Zoom.interpolate_property(self, 'zoom', self.zoom, Vector2(1,1) , 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
#			$Zoom.start()

func zoomin():
	$Zoom.interpolate_property(self, 'zoom', self.zoom, self.zoom - Vector2(0.10,0.10) , 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Zoom.start()
	
func zoomout():
	$Zoom.interpolate_property(self, 'zoom', self.zoom, self.zoom + Vector2(0.10,0.10) , 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Zoom.start()