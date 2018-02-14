extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var frames_increase = true

func _ready():
	pass
	
func _process():
	pass

func _on_Area2D_body_entered( body ):
	#BUG :- player is only recognised as entering body at certain angles
	#Solution Use Area2d so its not affected by physics
	#201 power up now ads score
	if body.is_in_group("player"):
		Global_Vars.score += 100
		$PowerUp.hide()
		$CollisionShape2D.disabled = true
		$PowerUp/AudioStreamPlayer.play()
		
func _on_AudioStreamPlayer_finished():
		queue_free()
