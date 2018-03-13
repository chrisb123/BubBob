extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
var vel = Vector2()

const SPEED_CONST = 1750
var SPEED = 1750
const jump_speed_const = -525
var jump_speed = -525
const FIRING_SPEED_CONST = 0.25 #0.3 normal
var FIRING_SPEED = 0.25 #0.3 normal

var onGround = 0
signal fired
var fired = 1
var facing = 1
var action = 0
var invincible = false

var StandBubble

var Screen_Shoot = 0
var Screen_Left = 0
var Screen_Right = 0
var Screen_Up = 0
var screen_xsize
var screen_ysize
var scrxa
var scrya
var scrxb
var scryb

var fire_ups = 0
var speed_ups = 0
var jump_ups = 0

var joypad_eventid = null
var shoot_eventid = null
var joypad_xpos = 150	# how to get this dynamically from GUI ?
var joypad_ypos = 600	# how to get this dynamically from GUI ?
var joypad_xoffset = 16	# to centre point
var joypad_yoffset = 23 # to centre point
var joypad_xcentre = joypad_xpos + joypad_xoffset
var joypad_ycentre = joypad_ypos + joypad_yoffset
var joypad_maxdistance = 300
var joypad_horizontal_velocity = 0

onready var SpeedGUI = get_node("/root/Main/GUI_Layer/Control/HBox/PowerUps/Speed")
onready var BubbleGUI = get_node("/root/Main/GUI_Layer/Control/HBox/PowerUps/Bubble")
onready var JumpGUI = get_node("/root/Main/GUI_Layer/Control/HBox/PowerUps/Jump")

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
	
	else:
		if ! is_on_floor():
			vel.y += delta * 700 #decelerate
		if vel.y > 1000: #max out falling speen
			vel.y = 1000
			
	if Input.is_action_pressed("ui_right") || Screen_Right:
		facing = 1
		$AnimatedSprite.flip_h = false
		if Screen_Right:
			vel.x += joypad_horizontal_velocity * delta
		else:
			vel.x += SPEED * delta
		if vel.x > 500:
			vel.x = 500
	if Input.is_action_pressed("ui_left") || Screen_Left:
		facing = -1
		$AnimatedSprite.flip_h = true
		if Screen_Left:
			vel.x -= joypad_horizontal_velocity * delta
		else:
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
			if is_on_ceiling() and vel.y < 0:
				data.killbub(true)
			if vel.y > 25 and ! StandBubble:
				StandBubble = col.collider
				StandBubble.squish()
				$OnBubble.start()
					
			#elif is_on_floor() && !is_on_wall() && !Input.is_action_pressed("ui_up"):
				#data.popbub()
		#if collide with monster, kill if in bubble, or player bounce off
		elif col.collider.is_in_group("enemy"):
			if col.collider._in_bubble == true:
				var data = col.collider
				data.linear_velocity += col.remainder * 2
				if is_on_ceiling() && !is_on_wall():
					data.killbub(true)
				if vel.y > 25 and ! StandBubble:
					StandBubble = col.collider
					$OnBubble.start()
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
		elif col.collider.is_in_group("tiles") and is_on_ceiling() and vel.y < 0:
			vel.y = 0		
	#If space is pressed fire bubble
	if (Input.is_action_pressed("ui_accept") || Screen_Shoot) && fired:
		fired = 0
		#shoot = 0
		$Timer.start()
		emit_signal("fired",facing)
		
func _on_Area2D_area_exited( area ):
	if area.get_parent() == StandBubble:
		if StandBubble.is_in_group("bubble"):
			StandBubble.unsquish()
		StandBubble = null
	
func _on_OnBubble_timeout():
	if StandBubble:
		if StandBubble.is_in_group("enemy"):
			StandBubble.killbub(true)
		elif StandBubble.is_in_group("bubble"):
			StandBubble.killbub(false)
		StandBubble = null

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

func _powerup_firing(factor,time):		#called by PowerUp
	fire_ups += time
	if $Timer.wait_time == FIRING_SPEED_CONST:
		var putext = BubbleGUI.get_node("Text")
		BubbleGUI.visible = true
		$Timer.wait_time = FIRING_SPEED / factor	 # (inverse) bubble shooting timer
		while fire_ups > 0:
			putext.text = str(fire_ups,"s")
			yield(get_tree().create_timer(1),"timeout")
			fire_ups -=1
		$Timer.wait_time = FIRING_SPEED_CONST
		BubbleGUI.visible = false
		
func _powerup_speed(factor,time):		#called by PowerUp
	speed_ups += time
	if SPEED == SPEED_CONST:
		var putext = SpeedGUI.get_node("Text")
		SpeedGUI.visible = true
		SPEED *= factor
		while speed_ups > 0:
			putext.text = str(speed_ups,"s")
			yield(get_tree().create_timer(1),"timeout")
			speed_ups -= 1
		SPEED = SPEED_CONST
		SpeedGUI.visible = false

func _powerup_jump(factor,time):	#called by PowerUp
	jump_ups += time
	if jump_speed == jump_speed_const:
		var putext = JumpGUI.get_node("Text")
		JumpGUI.visible = true
		jump_speed *= factor
		while jump_ups > 0:
			putext.text = str(jump_ups,"s")
			yield(get_tree().create_timer(1),"timeout")
			jump_ups -= 1
		jump_speed = jump_speed_const
		JumpGUI.visible = false

func _input(event):

#JOY PAD	

	#Record index of only first touch inside joypad
	if event.get_class() == ("InputEventScreenTouch") && joypad_eventid == null:
		if event.position.distance_to(Vector2(joypad_xcentre,joypad_ycentre)) < joypad_maxdistance:
			joypad_eventid = event.get_index()	

	#check screen touch release for IDX. if same set EventID to null
	elif event.get_class() == ("InputEventScreenTouch") && event.get_index() == joypad_eventid && !event.pressed:
		joypad_eventid = null
		Screen_Up = 0
		Screen_Left = 0
		Screen_Right = 0
		if OS.is_debug_build():
			get_node("/root/Main/Debug")._String2("NOT TOUCHED")

	#If touched or dragging, check index and alter movement if drag IDX is same as touch IDX. else ignore.
	elif (event.get_class() == ("InputEventScreenTouch") || event.get_class() == ("InputEventScreenDrag")) && joypad_eventid == event.get_index():
			if event.position.distance_to(Vector2(joypad_xcentre,joypad_ycentre)) < joypad_maxdistance && event.position.distance_to(Vector2(joypad_xcentre,joypad_ycentre)) > 40:
				var angle = rad2deg(Vector2(joypad_xcentre,joypad_ycentre).angle_to_point(event.position))
				if OS.is_debug_build():
					get_node("/root/Main/Debug")._String3(str(angle))

				if event.position.y < joypad_ycentre - 50:
					Screen_Up = 1
				else:
					Screen_Up = 0
					
				if event.position.x > joypad_xcentre:
					Screen_Left = 0
					Screen_Right = 1
					joypad_horizontal_velocity = -(SPEED / (joypad_maxdistance/2)) * (joypad_xcentre - event.position.x)
					if OS.is_debug_build():
						get_node("/root/Main/Debug")._String2(str("XAxisVel ",joypad_horizontal_velocity))
				else:
					Screen_Left = 1
					Screen_Right = 0
					joypad_horizontal_velocity = (SPEED / (joypad_maxdistance/2)) * (joypad_xcentre - event.position.x)
					if OS.is_debug_build():
						get_node("/root/Main/Debug")._String2(str("XAxisVel ",joypad_horizontal_velocity))
						
			else:
				Screen_Up = 0
				Screen_Left = 0
				Screen_Right = 0
				if OS.is_debug_build():
					get_node("/root/Main/Debug")._String2("OFF KEYPAD")
					get_node("/root/Main/Debug")._String2(str("XAxisVel 0"))

	
				
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






