extends Label

var time = 2

func msg(msg):
	self.text = msg
	if ! self.visible:
		$anim.play("fadein")
		self.visible = true
		yield(get_tree().create_timer(time),"timeout")
		$anim.play("fadeout")

func _on_anim_animation_finished(anim_name):
	if anim_name == "fadeout":
		self.visible = false
