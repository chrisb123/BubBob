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

func _ready():
	pass

func _physics_process(delta):
	rotation_degrees = 0
	if is_on_floor():
		vel.y = 0
	if is_on_ceiling():
		vel.y = 0	
	if Input.is_action_pressed("ui_up") && is_on_floor():
		vel.y = -SPEED * delta
		if vel.y < 425:
			vel.y = -425
	else:
		vel.y += delta * 700
		if vel.y > 1000:
			vel.y = 1000
	if Input.is_action_pressed("ui_right"):
		facing = 1
		$Sprite.flip_h = false
		vel.x += SPEED * delta
		if vel.x > 500:
			vel.x = 500
	if Input.is_action_pressed("ui_left"):
		facing = -1
		$Sprite.flip_h = true
		vel.x -= SPEED * delta
		if vel.x < -500:
			vel.x = -500
	vel.x /= 1 + delta * 5
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
			if is_on_ceiling():
				data.killbub()
			elif is_on_floor() && !is_on_wall() && !Input.is_action_pressed("ui_up"):
				data.popbub()
		#if collide with monster, kill if in bubble, or player bounce off
		elif col.collider.is_in_group("enemy"):
			if col.collider._in_bubble == true:
				var data = col.collider
				data.linear_velocity += col.remainder * 2
				if is_on_ceiling() && !is_on_wall():
					data.killbub()

			else:
				vel = Vector2(-3 * vel.x, 1 * vel.y).clamped(1000)
				if vel.x < 500 && vel.x > 0:
					vel.x = 500
				elif vel.x < 0 && vel.x > -500:
					vel.x = -500
	
	if Input.is_key_pressed(KEY_SPACE) && fired:
		fired = 0
		$Timer.start()
		emit_signal("fired",facing)

func _on_Timer_timeout():
	fired = 1
