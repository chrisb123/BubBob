extends RigidBody2D

# class member variables go here, for example:
# var a = 2
var SPEED = 400
var onGround = 0
signal fired
var fired = 1
var facing = 0
var action = 0

func _ready():
	pass#set_fixed_process(true)

func _process(delta):
	var vel = linear_velocity
	if Input.is_action_pressed("ui_up"):
		action = 1
		$Player.applyimpulse = Vector2(0, -1500)
	if Input.is_action_pressed("ui_right"):
		action = 1
		facing = 1
		vel.x += SPEED * delta
	if Input.is_action_pressed("ui_left"):
		action = 1
		facing = -1
		vel.x -= SPEED * delta
	if action:
		linear_velocity = vel
		action = 0
		
	
	if Input.is_action_pressed("ui_down") && fired:
		fired = 0
		$Timer.start()
		emit_signal("fired",facing)

func _on_Timer_timeout():
	fired = 1
