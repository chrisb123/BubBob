extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var frames_increase = true
var powerup_type

var shoot_factor = 2
var shoot_duration = 20

var speed_factor = 3
var speed_duration = 20

var jump_factor = 1.5
var jump_duration = 20

func _ready():
	if powerup_type == 1:	#bonus points
		$Coin.show()
		$Potion_Shoot.hide()
		$Potion_Speed.hide()
		$Potion_Jump.hide()
	elif powerup_type == 2: #Shooting speed
		$Coin.hide()
		$Potion_Shoot.show() 
		$Potion_Speed.hide()
		$Potion_Jump.hide()
	elif powerup_type == 3: #running_speed
		$Coin.hide()
		$Potion_Shoot.hide() 
		$Potion_Speed.show()
		$Potion_Jump.hide()
	elif powerup_type == 4: #jump_height
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
			body._powerup_firing(shoot_factor,shoot_duration)
		if powerup_type == 3:
			Global_Vars.score += 200
			$Potion_Speed.hide()
			$CollisionShape2D.disabled = true
			body._powerup_speed(speed_factor,speed_duration)
		if powerup_type == 4:
			Global_Vars.score += 250
			$Potion_Jump.hide()
			$CollisionShape2D.disabled = true
			body._powerup_jump(jump_factor,jump_duration)
		queue_free()	
