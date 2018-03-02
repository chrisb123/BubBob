extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var frames_increase = true
var powerup_type

var shoot_factor = 2
var shoot_duration = 20

var speed_factor = 2
var speed_duration = 20

var jump_factor = 1.3
var jump_duration = 20

func _ready():
	$Coin.hide()
	$Potion_Shoot.hide()
	$Potion_Speed.hide()
	$Potion_Jump.hide()
	$Potion_Particles.emitting = false
	$Potion_Particles.hide()
	
	if powerup_type == 1:	#bonus points
		$Coin.show()
		#$Potion_Shoot.hide()
		#$Potion_Speed.hide()
		#$Potion_Jump.hide()
	elif powerup_type == 2: #Shooting speed
		#$Coin.hide()
		$Potion_Shoot.show()
		if Global_Vars.Osys != "HTML5": 
			$Potion_Particles.emitting = true
			$Potion_Particles.show()
		#$Potion_Speed.hide()
		#$Potion_Jump.hide()
	elif powerup_type == 3: #running_speed
		#$Coin.hide()
		#$Potion_Shoot.hide() 
		$Potion_Speed.show()
		if Global_Vars.Osys != "HTML5": 
			$Potion_Particles.emitting = true
			$Potion_Particles.show()
		#$Potion_Jump.hide()
	elif powerup_type == 4: #jump_height
		#$Coin.hide()
		#$Potion_Shoot.hide() 
		#$Potion_Speed.hide()
		$Potion_Jump.show()
		if Global_Vars.Osys != "HTML5": 
			$Potion_Particles.emitting = true
			$Potion_Particles.show()

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
			$Potion_Shoot.hide()
			$CollisionShape2D.disabled = true
			body._powerup_firing(shoot_factor,shoot_duration)
			$Potion_SFX.play()
			yield($Potion_SFX,"finished")
		if powerup_type == 3:
			$Potion_Speed.hide()
			$CollisionShape2D.disabled = true
			body._powerup_speed(speed_factor,speed_duration)
			$Potion_SFX.play()
			yield($Potion_SFX,"finished")
		if powerup_type == 4:
			$Potion_Jump.hide()
			$CollisionShape2D.disabled = true
			body._powerup_jump(jump_factor,jump_duration)
			$Potion_SFX.play()
			yield($Potion_SFX,"finished")
		queue_free()	
