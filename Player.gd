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
const FIRING_SPEED = 0.15 #0.3 normal

func _ready():
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
	if Input.is_action_pressed("ui_up") && is_on_floor():
		vel.y = -SPEED * delta
		if vel.y < 425:
			vel.y = -525
	else:
		vel.y += delta * 700
		if vel.y > 1000:
			vel.y = 1000
	if Input.is_action_pressed("ui_right"):
		facing = 1
		$AnimatedSprite.flip_h = false
		vel.x += SPEED * delta
		if vel.x > 500:
			vel.x = 500
	if Input.is_action_pressed("ui_left"):
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
	if Input.is_action_pressed("ui_accept") && fired:
		fired = 0
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
