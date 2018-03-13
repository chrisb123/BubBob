extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var Text = get_parent().get_node("Text")

var frames_increase = true
var powerup_type

var coin_bonus = 100

var shoot_factor = 2
var shoot_duration = 20

var speed_factor = 2
var speed_duration = 20

var jump_factor = 1.3
var jump_duration = 20

const LIFE_TIME_CONST = 10

func _ready():
	$Life_Time.wait_time = LIFE_TIME_CONST / Global_Vars.Difficulty
	$Life_Time.start()
	
	Text.hide()
	$Coin.hide()
	$Potion_Shoot.hide()
	$Potion_Speed.hide()
	$Potion_Jump.hide()
	$Potion_Particles.emitting = false
	$Potion_Particles.hide()
	
	if powerup_type == 1:	#bonus points
		$Coin.show()
		$CollisionCoin.disabled = false
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
	if powerup_type > 1:
		$CollisionPotion.disabled = false

#func _process(delta):
#	pass
	#if Text.visible == true:
	#	Text.rect_position = self.position + Vector2(Text.rect_size.x/2 ,-50) #Move Text to Powerup Position
	#else:
	#	return

func _on_Area2D_body_entered( body ):
	#BUG :- player is only recognised as entering body at certain angles
	#Solution Use Area2d so its not affected by physics
	#201 power up now ads score
	
	if body.is_in_group("player"):
		$Life_Time.stop()	#DO NOT DELETE :- to prevent multiple functions Queue freeing. (Life Timeout while Yielding for SFX)
		Text.rect_position = self.position + Vector2(-Text.rect_size.x/2 ,-75) #Move Text to Powerup Position
		Text.show()
		$Potion_Particles.hide()
		if powerup_type == 1:
			Global_Vars.score += coin_bonus
			Text.text = str("+",coin_bonus, " Points")
			$Coin.hide()
			$CollisionCoin.disabled = true
			$Coin/AudioStreamPlayer.play()
			yield($Coin/AudioStreamPlayer,"finished")
		else:
			if powerup_type == 2:
				Text.set_text("Bubbles +")
				$Potion_Shoot.hide()
				body._powerup_firing(shoot_factor,shoot_duration)
			elif powerup_type == 3:
				Text.set_text("Speed +")
				$Potion_Speed.hide()
				body._powerup_speed(speed_factor,speed_duration)
			elif powerup_type == 4:
				Text.set_text("Jump +")
				$Potion_Jump.hide()
				body._powerup_jump(jump_factor,jump_duration)
			$CollisionPotion.disabled = true
			$Potion_SFX.play()
			yield($Potion_SFX,"finished")
		_delete()	

func _delete():
	get_parent().queue_free()

