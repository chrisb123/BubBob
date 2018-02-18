extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
var vel = Vector2()
var SPEED = 1750
const jump_speed = -525
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
const FIRING_SPEED = 0.25 #0.3 normal
var screen_xsize
var screen_ysize
var scrxa
var scrya
var scrxb
var scryb

var joypad_eventid = null
var shoot_eventid = null

func _ready():
	set_process_input(true)
	$Timer.wait_time = FIRING_SPEED
	screen_xsize = (get_viewport().get_visible_rect().size.x)
	screen_ysize = (get_viewport().get_visible_rect().size.y)
	scrxa = screen_xsize * 0.15
	scrya = screen_ysize * 0.15
	scrxb = screen_xsize * 0.85
	scryb = screen_ysize * 0.85

func _physics_process(delta):
	rotation_degrees = 0

	if Input.is_action_just_pressed("ui_page_down"): #page down for quit
		Global_Vars.gameover = true
	if Input.is_action_just_pressed("ui_page_up"):
		print("kill all")
		var enemies = get_tree().get_nodes_in_group("enemy")
		for i in enemies:
			print(i)
			i.get_node("AnimatedSprite").play()
	
	if is_on_floor():
		vel.y = 0
		if Input.is_action_pressed("ui_up") || Screen_Up:
			vel.y = jump_speed
#		vel.y = -SPEED * delta #justify this? why jump at a rate determined by delta
#		if vel.y < 425: #this makes no sense, if you are trying to jump and your velocity is smashing you into the ground
#			vel.y = -525 #then jump instead
	elif is_on_ceiling():
		vel.y = 0	
	else:
		vel.y += delta * 700 #decelerate
		if vel.y > 1000: #max out falling speen
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
					Global_Vars.score += Global_Vars.score_death
					Global_Vars.lives += 1
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
			Global_Vars.score += Global_Vars.score_death
			Global_Vars.lives += 1
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

#JOY PAD	

	#Record index of only first touch inside joypad
	if event.get_class() == ("InputEventScreenTouch") && joypad_eventid == null:
		if event.position.distance_to(Vector2(616,623)) < 300:
			joypad_eventid = event.get_index()	

	#check screen touch release for IDX. if same set EventID to null
	elif event.get_class() == ("InputEventScreenTouch") && event.get_index() == joypad_eventid && !event.pressed:
		joypad_eventid = null
		Screen_Up = 0
		Screen_Left = 0
		Screen_Right = 0
		get_node("/root/Main/Debug")._String2("NOT TOUCHED")

	#If touched or dragging, check index and alter movement if drag IDX is same as touch IDX. else ignore.
	elif (event.get_class() == ("InputEventScreenTouch") || event.get_class() == ("InputEventScreenDrag")) && joypad_eventid == event.get_index():
			if event.position.distance_to(Vector2(616,623)) < 300 && event.position.distance_to(Vector2(616,623)) > 40:
				var angle = rad2deg(Vector2(616,623).angle_to_point(event.position))
				if OS.is_debug_build():
					get_node("/root/Main/Debug")._String3(str(angle))

				if angle > 70 && angle < 110:
					Screen_Up = 1
					Screen_Left = 0
					Screen_Right = 0
					if OS.is_debug_build():
						get_node("/root/Main/Debug")._String2("UP")
	
				elif angle > 45 && angle < 70:
					Screen_Up = 1
					Screen_Left = 1
					Screen_Right = 0
					if OS.is_debug_build():
						get_node("/root/Main/Debug")._String2("UP LEFT")
				elif angle > -45 && angle < 20:
					Screen_Up = 0
					Screen_Left = 1
					Screen_Right = 0
					if OS.is_debug_build():
						get_node("/root/Main/Debug")._String2("LEFT")
					
				elif angle > 110 && angle < 135:
					Screen_Up = 1
					Screen_Left = 0
					Screen_Right = 1
					if OS.is_debug_build():
						get_node("/root/Main/Debug")._String2("UP RIGHT")
				elif angle > 135 && angle < 180 || angle > -180 && angle < -135: #Angle (0 - 180 degrees CW and 0 - -180 degrees CCW)
					Screen_Up = 0
					Screen_Left = 0
					Screen_Right = 1
					if OS.is_debug_build():
						get_node("/root/Main/Debug")._String2("RIGHT")
			else:
				Screen_Up = 0
				Screen_Left = 0
				Screen_Right = 0
				if OS.is_debug_build():
					get_node("/root/Main/Debug")._String2("OFF KEYPAD")
				
#Shoot Bubbles
	#Set index only on first tough
	if event.get_class() == ("InputEventScreenTouch") && shoot_eventid == null:
		if event.position.x > scrxb && event.position.y > scryb:
			Screen_Shoot = 1
			shoot_eventid = event.get_index()

	#Rest index and stop shooting upon touch release
	elif event.get_class() == ("InputEventScreenTouch") && shoot_eventid == event.get_index() && !event.pressed:
		Screen_Shoot = 0
		shoot_eventid = null
	
	
	

	#Bad idea to process constants in a loop, also no longer needed
	#var ShootButton = Vector2(screen_xsize * 0.90, screen_ysize * 0.90) # somewhere on lower left
	#var CentreButton =  Vector2(screen_xsize * 0.10, screen_ysize * 0.90) # somewhere on lower right
	#var LeftButton = CentreButton + Vector2(-50,0)
	#var RightButton = CentreButton + Vector2(50,0)
	#var UpButton = CentreButton + Vector2(0,-50)
	#var event_pos = Vector2()
	#print(event.get_class())
	
"""	if event.get_class() == ("InputEventScreenTouch"):
		event_pos = event.position #Becuase too many input classes have no position variable, causing a crash
		if event_pos.x > scrxb and event_pos.y > scryb - scrya && event.is_pressed() == true:
			if event_pos.y > scryb:
				Screen_Shoot = 1
				Screen_Up = 0
			else: 
				print("up")
				Screen_Shoot = 0
				Screen_Up = 1
		
		#starts movement with just press, in case player does not drag yet	
		if event.is_pressed() == true and event_pos.x < scrxa * 2 and event_pos.y > scryb:
			if event_pos.x < scrxa: 
				print("Left")
				Screen_Left = 1
				Screen_Right = 0
			else: 
				print("right")
				Screen_Left = 0
				Screen_Right = 1
				
			
	if event.get_class() == ("InputEventScreenTouch") && event.is_pressed() == false:
		event_pos = event.position #Becuase too many input classes have no position variable, causing a crash
		if event_pos.x > (screen_xsize / 2):
			Screen_Shoot = 0
			Screen_Up = 0
		else: #release occured on left side, so reset movement
			Screen_Left = 0
			Screen_Right = 0
				
		
	if event.get_class() == ("InputEventScreenDrag"):
		event_pos = event.position
		
		if event_pos.x > scrxb and event_pos.y > scryb - scrya:
			if event_pos.y > scryb:
				Screen_Shoot = 1
				Screen_Up = 0
			else: 
				print("up")
				Screen_Shoot = 0
				Screen_Up = 1
		elif event_pos.x > (screen_xsize / 2):
			Screen_Shoot = 0
			Screen_Up = 0
			
		
		#starts movement with just press, in case player does not drag yet	
		if event_pos.x < scrxa * 2 and event_pos.y > scryb:
			if event_pos.x < scrxa: 
				print("Left")
				Screen_Left = 1
				Screen_Right = 0
			else: 
				print("right")
				Screen_Left = 0
				Screen_Right = 1
		elif event_pos.x < (screen_xsize / 2):
			Screen_Left = 0
			Screen_Right = 0
			
"""
		

