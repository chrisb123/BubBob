extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var Text = get_parent().get_node("Text")
var _in_bubble = false
var vel = Vector2()
var MIN_SPEED = 0	#Set in ready based upon phone or PC
var MAX_SPEED = 0	#Set in ready based upon phone or PC
const Y_SPEED_REDUCTION = 0.5 #divisor factor for Y axis speeds
var Explode = load("res://Explosion.tscn")
var Fireball = load("res://Fireball.tscn")
var _is_minion = false
var facing #1 right, 2 left
const NUM_FIREBALLS = 8
export (int) var enemy_type 
var score_for_killing 
const bubble_size = Vector2(0.075,0.075)
var ray = Vector2()
var free_move = false
var coldir = 0

#add variables and node from other enemies
#add enemy_type variable
#initialise scene depending on enemy_type
# - Need to add in different speeds and other changes to make enemies different
func _ready():
	if OS.has_touchscreen_ui_hint():
		MIN_SPEED = int(100 * Global_Vars.Difficulty)
		MAX_SPEED = int(250 * Global_Vars.Difficulty)
	else:
		MIN_SPEED = int(150 * Global_Vars.Difficulty)
		MAX_SPEED = int(350 * Global_Vars.Difficulty)
	
	$Bubble.scale = bubble_size
	Text.hide()
	randomize()
	if enemy_type == 1:
		$Enemy.region_rect = Rect2(0,0,80,100)
		score_for_killing = int(Global_Vars.score_enemy1 * Global_Vars.Difficulty)
	if enemy_type == 2:
		$Enemy.region_rect = Rect2(73,0,70,100)
		score_for_killing = int(Global_Vars.score_enemy2 * Global_Vars.Difficulty)
		$Fireball_Timer.wait_time = 3
		$Fireball_Timer.start()
	if enemy_type == 3:
		$Enemy.region_rect = Rect2(143,0,70,100)
		score_for_killing = int(Global_Vars.score_enemy3 * Global_Vars.Difficulty)
		$Fireball_Timer.wait_time = 2
		$Fireball_Timer.start()
		
	if get_parent().is_in_group("enemyboss"):
		_is_minion = true

	$Bubble_Timer.wait_time = 10 / Global_Vars.Difficulty
	$Enemy/RayL.add_exception(self)
	$Enemy/RayR.add_exception(self)
#func _process(delta):

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
		if !_is_minion:
			Text.rect_position = self.position + Vector2(-Text.rect_size.x/2 ,-75) #Move Text to Powerup Position
			Text.show()
			Text.text = str("+", score_for_killing, " points")
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
	if _is_minion == false:
		Global_Vars.score += score_for_killing
		Global_Vars.enemyn -= 1
	else:
		get_parent().get_parent().minion_count -= 1
	get_parent().queue_free()


func _on_RigidBody2D_body_entered( body ):
	if body.is_in_group("bubble") && ! _in_bubble:
		body.queue_free()
		$Bubble.show()
		_in_bubble = true
		$Bubble_Timer.start()
		if enemy_type != 1:
			$Fireball_Timer.stop()
		#Shrink monster into bubble (Animated)
		$Enemy/Shrink.interpolate_property($Enemy, 'scale', $Enemy.get_scale(),
		Vector2(0.33,0.33), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
		#$Enemy/Shrink.set_speed_scale(5)
		$Enemy/Shrink.start() 
		gravity_scale = -0.5
		bounce = 0.35
		linear_velocity.x = vel.x / 5
		linear_velocity.y = vel.y / 5
		#$Enemy.scale = Vector2(0.33,0.33)


func _on_Move_Timer_timeout():
#Randomize Enemy direction and speed every timeout
	
	var temp = randi()%2
	if temp == 1:
		vel.x = randi()%MAX_SPEED
		vel.x = clamp(vel.x, MIN_SPEED,MAX_SPEED)
		facing = 1
		$Enemy.flip_h = false
	else:
		vel.x = -1 * randi()%MAX_SPEED
		vel.x = clamp(vel.x, -MAX_SPEED,-MIN_SPEED)
		facing = -1
		$Enemy.flip_h = true
	var temp2 = randi()%2
	if temp2 == 1:
		vel.y = randi()%MAX_SPEED
		vel.y = clamp(vel.y, MIN_SPEED/Y_SPEED_REDUCTION,MAX_SPEED/Y_SPEED_REDUCTION)
	else:
		vel.y = -1 * randi()%MAX_SPEED
		vel.y = clamp(vel.y, -MAX_SPEED/Y_SPEED_REDUCTION,-MIN_SPEED/Y_SPEED_REDUCTION)
	#print(temp," ",temp2)
	if _in_bubble == false:
		ray = vel.normalized() * 100
		$Enemy/RayL.cast_to = ray.rotated(.5)
		$Enemy/RayR.cast_to = ray.rotated(-.5)
		#linear_velocity.x = vel.x
		#linear_velocity.y = vel.y
		$Enemy/Move.interpolate_property(self, 'linear_velocity', linear_velocity, Vector2(vel.x,vel.y), 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Enemy/Move.start()

func _process(delta):
	if $Enemy/RayL.is_colliding() and _in_bubble == false:
		coldir = 1
	elif $Enemy/RayR.is_colliding() and _in_bubble == false:
		coldir = -1
	if ! coldir == 0:
		var col
		if coldir == 1:
			col = $Enemy/RayL.get_collider()
		elif coldir == -1:
			col = $Enemy/RayR.get_collider()
		if col and ! col.is_in_group("player"):
			ray = ray.rotated(-.2 * coldir)
			vel = vel.rotated(-.2 * coldir)
			$Enemy/RayL.cast_to = ray.rotated(.5)
			$Enemy/RayR.cast_to = ray.rotated(-.5)
			free_move = true
			coldir = 0
	elif free_move:	
		free_move = false
		$Enemy/Move.interpolate_property(self, 'linear_velocity', linear_velocity, Vector2(vel.x,vel.y), 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Enemy/Move.start()

func _on_Bubble_Timer_timeout():
	#Remove Bubble and expand Enemy to original size
	$Enemy/Pop.interpolate_property($Enemy, 'scale', $Enemy.get_scale(),
	Vector2(0.8,0.8), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Enemy/Pop.interpolate_property($Bubble, 'scale', $Bubble.get_scale(),
	(bubble_size * 2), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Enemy/Pop.start() 
	gravity_scale = 0
	bounce = 0
	


func _on_Pop_tween_completed( object, key ):
	$Pop_Bubble.play()
	$Enemy/Shrink.interpolate_property($Enemy, 'scale', $Enemy.get_scale(),
	Vector2(0.75,0.75), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Enemy/Shrink.start() 
	$Bubble.hide() 
	$Bubble.scale = bubble_size
	$Bubble_Timer.stop()
	_in_bubble = false
	if enemy_type != 1:
		$Fireball_Timer.start()

#add fireball function from other enemies execute based on type
func _on_Fireball_Timer_timeout():
	if enemy_type == 2:
		var pos = $Enemy.position
		var rot = 0
		var lin = int(150 * Global_Vars.Difficulty)
		var i = 1
		pos.x += 0 #* facing
		pos.y -= 0
		while i <= NUM_FIREBALLS:
			var fireball = Fireball.instance()
			rot = (360 / NUM_FIREBALLS) * i
			fireball.rotation_degrees = rot
			lin += 0
			fireball.apply_impulse(Vector2(0,0), Vector2(lin * 1,0).rotated(deg2rad(rot)))
			fireball.position = pos
			add_child(fireball)
			i += 1
	if enemy_type == 3:
		var fireball = Fireball.instance()
		var pos = $Enemy.position
		pos.x += 50 * facing
		pos.y -= 0
		fireball.linear_velocity = Vector2(300 * Global_Vars.Difficulty * facing,0)
		if fireball.linear_velocity.x > 0:
			fireball.rotation_degrees += 0 
		else:
			fireball.rotation_degrees += 180
		fireball.position = pos
		add_child(fireball)