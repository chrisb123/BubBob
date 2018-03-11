extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var _in_bubble = false
var vel = Vector2()
var MAX_MINIONS = int(4 * Global_Vars.Difficulty)
var MIN_SPEED = 0	# set in _ready
var MAX_SPEED = 0	#set in _ready
const Y_SPEED_REDUCTION = 0.5 #divisor factor for Y axis speeds
var Explode = load("res://Explosion.tscn")
var Fireball = load("res://Fireball.tscn")
var Enemy = load("res://Enemy.tscn")
var facing = 1
var minion_count = 0
var bubble_count = 0
var RotationInc = 18
var rottemp = 0
var FireballCount = 12
var FireballSpeed = 250
var score_for_killing = Global_Vars.score_enemyboss1 
export (int) var boss_type 
const bubble_size = Vector2(0.075,0.075)
const bubble_size_inc = Vector2(0.005,0.005)

#setup boss type
func _ready():
	if OS.has_touchscreen_ui_hint():
		MIN_SPEED = int(100 * Global_Vars.Difficulty)
		MAX_SPEED = int(250 * Global_Vars.Difficulty)
	else:
		MIN_SPEED = int(150 * Global_Vars.Difficulty)
		MAX_SPEED = int(350 * Global_Vars.Difficulty)
			
	var Announce = get_node("/root/Main/GUI_Layer/Control/Announce")
	Announce.msg("Boss fight")
	$Bubble.scale = bubble_size
	if boss_type == 1:
		$Enemy.region_rect = Rect2(0,0,80,100)
		score_for_killing = int(Global_Vars.score_enemyboss1 * Global_Vars.Difficulty)
		$Minion_Spawn.wait_time = 1 / Global_Vars.Difficulty
	if boss_type == 2:
		$Enemy.region_rect = Rect2(73,0,70,100)
		score_for_killing = int(Global_Vars.score_enemyboss2 * Global_Vars.Difficulty)
		$Minion_Spawn.wait_time = 0.5 / Global_Vars.Difficulty
	if boss_type == 3:
		$Enemy.region_rect = Rect2(143,0,70,100)
		score_for_killing = int(Global_Vars.score_enemyboss3 * Global_Vars.Difficulty)
		$Minion_Spawn.wait_time = 3 / Global_Vars.Difficulty
		
	$Bubble_Timer.wait_time = 15 / Global_Vars.Difficulty #Defeating boss too hard
	$Enemy/Ray.add_exception(self)

#no need to process physics every frame for rigid bodies
#func _physics_process(delta):
#	rotation_degrees = 0
#	if _in_bubble == false:
#		linear_velocity.x = vel.x
#		linear_velocity.y = vel.y
#	else:
#		gravity_scale = -0.5
#		bounce = 0.35
#		if linear_velocity.x > 50:
#			linear_velocity.x = linear_velocity.x * 0.97
#		if linear_velocity.y > 50:
#			linear_velocity.y = linear_velocity.y * 0.97


func killbub(pk):
	if _in_bubble && pk:
		#Stop enemy
		$AnimatedSprite.play()
		$Death_Sound.play()
		if Global_Vars.Osys != "HTML5":
			$Particles.emitting = true
		$Enemy.hide()
		$Bubble.hide()
		$Move_Timer.stop()
		$CollisionShape2D.disabled = true
		linear_damp = 10
		linear_velocity = Vector2(0,0)
#And explode it
func _on_AnimatedSprite_animation_finished():
	Global_Vars.score += score_for_killing
	Global_Vars.enemyn -= 1
	queue_free()


func _on_RigidBody2D_body_entered( body ):
	if body.is_in_group("bubble") && ! _in_bubble:
		body.queue_free()
		$Bubble.show()
		$Bubble.scale += bubble_size_inc
		bubble_count += 1
		if bubble_count == 20:
			_in_bubble = true
			$Bubble_Timer.start()
			#Shrink monster into bubble (Animated)
			$Enemy/Shrink.interpolate_property($Enemy, 'scale', $Enemy.get_scale(),
			Vector2(0.75,0.75), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
			#$Enemy/Shrink.set_speed_scale(5)
			$Enemy/Shrink.start() 
			gravity_scale = -0.5
			bounce = 0.35
			linear_velocity.x = vel.x / 5
			linear_velocity.y = vel.y / 5
			#$Enemy.scale = Vector2(0.33,0.33)
			$Bubble_Shrink.stop()

		if bubble_count > 0:
			$Bubble_Shrink.start()
		else:
			$Bubble_Shrink.stop()

func _on_Move_Timer_timeout():
#Randomize Enemy direction and speed every timeout
	randomize()
	var temp = randi()%2
	if temp == 1:
		vel.x = randi()%MAX_SPEED
		vel.x = clamp(vel.x, MIN_SPEED,MAX_SPEED)
		$Enemy.flip_h = false
		facing = 1
	else:
		vel.x = -1 * randi()%MAX_SPEED
		vel.x = clamp(vel.x, -MAX_SPEED,-MIN_SPEED)
		$Enemy.flip_h = true
		facing = -1
	var temp2 = randi()%2
	if temp2 == 1:
		vel.y = randi()%MAX_SPEED
		vel.y = clamp(vel.y, MIN_SPEED/Y_SPEED_REDUCTION,MAX_SPEED/Y_SPEED_REDUCTION)
	else:
		vel.y = -1 * randi()%MAX_SPEED
		vel.y = clamp(vel.y, -MAX_SPEED/Y_SPEED_REDUCTION,-MIN_SPEED/Y_SPEED_REDUCTION)
	#print(temp," ",temp2)
	if _in_bubble == false:
		var ray = vel.normalized() * 100
		$Enemy/Ray.cast_to = ray
		#linear_velocity.x = vel.x
		#linear_velocity.y = vel.y
		$Enemy/Move.interpolate_property(self, 'linear_velocity', linear_velocity, Vector2(vel.x,vel.y), 0.25, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$Enemy/Move.start()

func _process(delta):
	if $Enemy/Ray.is_colliding() and _in_bubble == false:
		var col = $Enemy/Ray.get_collider()
#		if ! col.is_in_group("player"):
		print ("avoid object ", col)
		_on_Move_Timer_timeout()

func _on_Bubble_Timer_timeout():
	#Remove Bubble and expand Enemy to original size
	$Enemy/Pop.interpolate_property($Enemy, 'scale', $Enemy.get_scale(),
	Vector2(3.0,3.0), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Enemy/Pop.interpolate_property($Bubble, 'scale', $Bubble.get_scale(),
	($Bubble.get_scale() * 2), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Enemy/Pop.start() 
	gravity_scale = 0
	bounce = 0


func _on_Pop_tween_completed( object, key ):
	if Global_Vars.Osys != "HTML5":
		$Particles_start.emitting = true
	$Pop_Bubble.play()
	$Enemy/Shrink.interpolate_property($Enemy, 'scale', $Enemy.get_scale(),
	Vector2(2.0,2.0), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Enemy/Shrink.start() 
	$Bubble.hide() 
	$Bubble.scale = bubble_size
	$Bubble_Timer.stop()
	bubble_count = 0
	_in_bubble = false

#add code from each boss for its special power
func _on_Minion_Spawn_timeout():
	if _in_bubble == false and boss_type == 1:
		if minion_count < MAX_MINIONS:
			var enemy = Enemy.instance()
			var pos = $Enemy.position
			pos.x += 50 * facing
			pos.y -= 0
			minion_count += 1
			add_child(enemy)
			enemy.get_node("Enemy")._is_minion = true

	if _in_bubble == false and boss_type == 2:
		var pos = $Enemy.position
		var lin = int(150 * Global_Vars.Difficulty)
		pos.x += 0 #* facing
		pos.y = -30
		var fireball = Fireball.instance()
		rottemp += RotationInc
		if rottemp > 360:
			rottemp = RotationInc
		#rot = (360 / NUM_FIREBALLS) * i
		fireball.rotation_degrees = rottemp
		fireball.apply_impulse(Vector2(0,0), Vector2(lin * 1,0).rotated(deg2rad(rottemp)))
		fireball.position = pos
		add_child(fireball)
			
	if _in_bubble == false and boss_type == 3:
		var yoffset = -50
		for i in range(FireballCount):
			i += 1
			var fireball = Fireball.instance()
			var pos = $Enemy.position
			pos.x += 50 * facing
			if yoffset > 50:
				yoffset = -50				
			pos.y += yoffset
			fireball.linear_velocity = Vector2(float((FireballSpeed + FireballSpeed / FireballCount * i) * Global_Vars.Difficulty) * facing,0)
			if fireball.linear_velocity.x > 0:
				fireball.rotation_degrees += 0 
			else:
				fireball.rotation_degrees += 180
			fireball.position = pos
			yoffset += 50
			add_child(fireball)


func _on_Bubble_Shrink_timeout():
	if $Bubble.scale > bubble_size:
		$Bubble.scale -= bubble_size_inc
	if bubble_count > 0:
		bubble_count -= 1
	if bubble_count < 1:
		$Bubble.hide()
	