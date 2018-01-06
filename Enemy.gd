extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var _in_bubble = false
var vel = Vector2()
const MIN_SPEED = 150
const MAX_SPEED = 350
export (PackedScene) var Explode


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if _in_bubble == true:
		if $Bubble_Timer.is_stopped():
			$Bubble_Timer.start()
	

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
		$Particles.emitting = true
		$Enemy.hide()
		$Bubble.hide()
		$Move_Timer.stop()
		$CollisionShape2D.disabled = true
		linear_damp = 10
		linear_velocity = Vector2(0,0)
#And explode it
func _on_AnimatedSprite_animation_finished():
	Global_Vars.score += 1
	queue_free()


func _on_RigidBody2D_body_entered( body ):
	if body.is_in_group("bubble") && ! _in_bubble:
		body.queue_free()
		$Bubble.show()
		_in_bubble = true
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
	randomize()
	var temp = randi()%2
	if temp == 1:
		vel.x = randi()%MAX_SPEED
		vel.x = clamp(vel.x, MIN_SPEED,MAX_SPEED)
	else:
		vel.x = -1 * randi()%MAX_SPEED
		vel.x = clamp(vel.x, -MAX_SPEED,-MIN_SPEED)
	var temp2 = randi()%2
	if temp2 == 1:
		vel.y = randi()%MAX_SPEED
		vel.y = clamp(vel.y, MIN_SPEED,MAX_SPEED)
	else:
		vel.y = -1 * randi()%MAX_SPEED
		vel.y = clamp(vel.y, -MAX_SPEED,-MIN_SPEED)
	#print(temp," ",temp2)
	if _in_bubble == false:
		linear_velocity.x = vel.x
		linear_velocity.y = vel.y
	

func _on_Bubble_Timer_timeout():
	#Remove Bubble and expand Enemy to original size
	$Enemy/Pop.interpolate_property($Enemy, 'scale', $Enemy.get_scale(),
	Vector2(0.8,0.8), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Enemy/Pop.interpolate_property($Bubble, 'scale', $Enemy.get_scale(),
	Vector2(2.0,2.0), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Enemy/Pop.start() 
	gravity_scale = 0
	bounce = 0


func _on_Pop_tween_completed( object, key ):

	$Enemy/Shrink.interpolate_property($Enemy, 'scale', $Enemy.get_scale(),
	Vector2(0.5,0.5), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Enemy/Shrink.start() 
	$Bubble.hide() 
	$Bubble.scale = Vector2(1.0,1.0)
	$Bubble_Timer.stop()
	_in_bubble = false
