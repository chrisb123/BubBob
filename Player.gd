extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
var vel = Vector2()
var SPEED = 1750
var onGround = 0
signal fired
var fired = 1
var facing = 1
var action = 0
var invincible = false
var Screen_Shoot = 0
var Screen_Left = 0
var Screen_Right = 0
var Screen_Up = 0
const FIRING_SPEED = 0.15 #0.3 normal

func _ready():
	set_process_input(true)
	$Timer.wait_time = FIRING_SPEED

func _physics_process(delta):
	rotation_degrees = 0
	if is_on_floor():
		vel.y = 0
	if is_on_ceiling():
		vel.y = 0	
	if Input.is_action_just_pressed("ui_page_up"):
		print("kill all")
		var enemies = get_tree().get_nodes_in_group("enemy")
		for i in enemies:
			print(i)
			i.get_node("AnimatedSprite").play()
	if (Input.is_action_pressed("ui_up") || Screen_Up) && is_on_floor():
		vel.y = -SPEED * delta
		if vel.y < 425:
			vel.y = -525
	else:
		vel.y += delta * 700
		if vel.y > 1000:
			vel.y = 1000
	if Input.is_action_pressed("ui_right") || Screen_Right:
		facing = 1
		$AnimatedSprite.flip_h = false
		vel.x += SPEED * delta
		if vel.x > 500:
			vel.x = 500
	if Input.is_action_pressed("ui_left") || Screen_Left:
		facing = -1
		$AnimatedSprite.flip_h = true
		vel.x -= SPEED * delta
		if vel.x < -500:
			vel.x = -500
	vel.x /= 1 + delta * 5
	if vel.y < 0:
		$AnimatedSprite.animation = "jump"
	elif vel.y > 100:
		$AnimatedSprite.animation = "fall"	
	elif vel.x > 20 or vel.x < -20:
		if $AnimatedSprite.animation == "fall":
			$AnimatedSprite/Land.play()
		$AnimatedSprite.animation = "running"
	else:
		if $AnimatedSprite.animation == "fall":
			$AnimatedSprite/Land.play()
		$AnimatedSprite.animation = "idle"
	move_and_slide(vel,Vector2(0,-1))
	var coli = get_slide_count()
	while(coli > 0):
		coli -= 1
		var col = get_slide_collision(coli)
		#if collide with bubble then pop bubble
		if col.collider.is_in_group("bubble"):
			var data = col.collider
			#data.linear_velocity += col.remainder * 2
			data.apply_impulse(Vector2(),col.remainder)
			#hit bubble with head (explode), hit bubble with feet (shirnk/vanish)
			if is_on_ceiling() && vel.y < 0:
				data.killbub(true)
			#elif is_on_floor() && !is_on_wall() && !Input.is_action_pressed("ui_up"):
				#data.popbub()
		#if collide with monster, kill if in bubble, or player bounce off
		elif col.collider.is_in_group("enemy"):
			if col.collider._in_bubble == true:
				var data = col.collider
				data.linear_velocity += col.remainder * 2
				if is_on_ceiling() && !is_on_wall():
					data.killbub(true)

			else:
				if invincible == false:
					invincible = true
					Global_Vars.lives -= 1
					$Invincible_Timer.start()
					$AnimatedSprite/Pain.play()
					#$Sprite.scale = Vector2(0.5, 0.5)
				vel = Vector2(-3 * vel.x, 1 * vel.y).clamped(1000)
				if vel.x < 500 && vel.x > 0:
					vel.x = 500
				elif vel.x < 0 && vel.x > -500:
					vel.x = -500
	#If space is pressed fire bubble
	if (Input.is_action_pressed("ui_accept") || Screen_Shoot) && fired:
		fired = 0
		#shoot = 0
		$Timer.start()
		emit_signal("fired",facing)

func _on_Timer_timeout():
	fired = 1

func _on_Invincible_Timer_timeout():
	$Invincible_Timer.stop()
	invincible = false
	$AnimatedSprite.visible = true
	#$Sprite.scale = Vector2(1.25, 1.25)
	

func _on_Area2D_area_entered( area ):
	if area.get_parent().is_in_group("fireball"):
		if invincible == false:
			invincible = true
			Global_Vars.lives -= 1
			$Invincible_Timer.start()
			$AnimatedSprite/Pain.play()
			#$Sprite.scale = Vector2(0.5, 0.5)
			vel = Vector2(-3 * vel.x, 1 * vel.y).clamped(1000)
			if vel.x < 500 && vel.x > 0:
				vel.x = 500
			elif vel.x < 0 && vel.x > -500:
				vel.x = -500
			area.get_parent()._die()
	pass # replace with function body


func _on_Invincible_Flash_timeout():
	if invincible == true:
		if $AnimatedSprite.visible == true:
			$AnimatedSprite.visible = false
		else:
			$AnimatedSprite.visible = true
	else:
		$AnimatedSprite.visible = true
		
func _input(event):
	var screen_xsize = (get_viewport().get_visible_rect().size.x)
	var screen_ysize = (get_viewport().get_visible_rect().size.y)

	var ShootButton = Vector2(screen_xsize * 0.75, screen_ysize * 0.75) # somewhere on lower left
	var CentreButton =  Vector2(screen_xsize * 0.25, screen_ysize * 0.75) # somewhere on lower right
	var LeftButton = CentreButton + Vector2(-50,0)
	var RightButton = CentreButton + Vector2(50,0)
	var UpButton = CentreButton + Vector2(0,-50)
	var event_pos = Vector2()
	#print(event.get_class())
	
	if event.get_class() == ("InputEventScreenTouch"):
		event_pos = event.position #Becuase too many input classes have no position variable, causing a crash
		if event_pos.distance_to(ShootButton) < 100 && event.is_pressed() == true:
			Screen_Shoot = 1
		#starts movement with just press, in case player does not drag yet	
		if event_pos.distance_to(LeftButton) < 50 && event.is_pressed() == true: 
			print("Left")
			Screen_Left = 1
			Screen_Right = 0
			Screen_Up = 0
		if event_pos.distance_to(RightButton) < 50 && event.is_pressed() == true:
			print("right")
			Screen_Left = 0
			Screen_Right = 1
			Screen_Up = 0
		if event_pos.distance_to(UpButton) < 50 && event.is_pressed() == true:
			print("up")
			Screen_Left = 0
			Screen_Right = 0
			Screen_Up = 1
			
	if event.get_class() == ("InputEventScreenTouch") && event.is_pressed() == false:
		event_pos = event.position #Becuase too many input classes have no position variable, causing a crash
		Screen_Shoot = 0
		if event_pos.x < (screen_xsize / 2): #release occured on left side, so reset movement
			Screen_Left = 0
			Screen_Right = 0
			Screen_Up = 0
				
		
	if event.get_class() == ("InputEventScreenDrag"):
		event_pos = event.position
		
		if event_pos.distance_to(LeftButton) < 50:
			print("Left")
			Screen_Left = 1
			Screen_Right = 0
			Screen_Up = 0
		if event_pos.distance_to(RightButton) < 50:
			print("right")
			Screen_Left = 0
			Screen_Right = 1
			Screen_Up = 0
		if event_pos.distance_to(UpButton) < 50:
			print("up")
			Screen_Left = 0
			Screen_Right = 0
			Screen_Up = 1
