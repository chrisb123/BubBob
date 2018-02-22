extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var frames_increase = true
var powerup_type

func _ready():
	if powerup_type == 1:
		$Coin.show()
		$Potion_Shoot.hide()
		$Potion_Speed.hide()
		$Potion_Jump.hide()
	elif powerup_type == 2:
		$Coin.hide()
		$Potion_Shoot.show() 
		$Potion_Speed.hide()
		$Potion_Jump.hide()
	elif powerup_type == 3:
		$Coin.hide()
		$Potion_Shoot.hide() 
		$Potion_Speed.show()
		$Potion_Jump.hide()
	elif powerup_type == 4:
		$Coin.hide()
		$Potion_Shoot.hide() 
		$Potion_Speed.hide()
		$Potion_Jump.show()

func _process():
	pass

func _on_Area2D_body_entered( body ):
	#BUG :- player is only recognised as entering body at certain angles
	#Solution Use Area2d so its not affected by physics
	#201 power up now ads score
	if body.is_in_group("player"):
		if powerup_type == 1:
			Global_Vars.score += 100
			$Coin.hide()
			$CollisionShape2D.disabled = true
			$Coin/AudioStreamPlayer.play()
			yield($Coin/AudioStreamPlayer,"finished")
		if powerup_type == 2:
			Global_Vars.score += 150
			$Potion_Shoot.hide()
			$CollisionShape2D.disabled = true
			body._firing_factor()
		if powerup_type == 3:
			Global_Vars.score += 200
			$Potion_Speed.hide()
			$CollisionShape2D.disabled = true
			body._speed_factor()
		if powerup_type == 4:
			Global_Vars.score += 250
			$Potion_Jump.hide()
			$CollisionShape2D.disabled = true
			body._jump_factor()
		queue_free()	
