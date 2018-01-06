extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
var vel = Vector2()
var SPEED = 1000
var onGround = 0
signal fired
var fired = 1
var facing = 1
var action = 0
var invincible = false
const FIRING_SPEED = 0.1 #0.3 normal

func _ready():
	$Timer.wait_time = FIRING_SPEED

func _physics_process(delta):
	rotation_degrees = 0
	if is_on_floor():
		if $AnimatedSprite.animation != "running":
			$AnimatedSprite.animation = "idle"
		vel.y = 0
	if is_on_ceiling():
		$AnimatedSprite.animation = "fall"
		vel.y = 0	
	if Input.is_action_pressed("ui_up") && is_on_floor():
		$AnimatedSprite.animation = "jump"
		vel.y = -SPEED * delta
		if vel.y < 425:
			vel.y = -425
	else:
		vel.y += delta * 700
		if vel.y > 1000:
			vel.y = 1000
	if Input.is_action_pressed("ui_right"):
		facing = 1
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.animation = "running"
		vel.x += SPEED * delta
		if vel.x > 500:
			vel.x = 500
	if Input.is_action_pressed("ui_left"):
		facing = -1
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.animation = "running"
		vel.x -= SPEED * delta
		if vel.x < -500:
			vel.x = -500
	vel.x /= 1 + delta * 5
	if $AnimatedSprite.animation != "idle" and vel.x < 20:
		$AnimatedSprite.animation = "idle"
	move_and_slide(vel,Vector2(0,-1))
	var coli = get_slide_count()
	while(coli > 0):
		coli -= 1
		var col = get_slide_collision(coli)
		#if collide with bubble then pop bubble
		if col.collider.is_in_group("bubble"):
			var data = col.collider
			data.linear_velocity += col.remainder * 2
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
					$Sprite.scale = Vector2(0.5, 0.5)
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
	$Sprite.scale = Vector2(1.25, 1.25)
	
