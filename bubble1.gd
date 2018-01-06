extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (int) var facing
var velocity = 250
var dying = false
var player_pushing = false
const LIFE_TIME = 10
const pop_time = 0.75

func _ready():
	$Life.wait_time = LIFE_TIME
	linear_velocity.x = velocity * facing
	$Sprite.scale = Vector2(0.1,0.1)
	$Sprite/Grow.interpolate_property($Sprite, 'scale', $Sprite.get_scale(), Vector2(1,1) , 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Sprite/Grow.start()
	#print(facing)

func _process(delta):
	#if playing is not pushing they limit min speed
	if !player_pushing:
		if linear_velocity.x < 25 && linear_velocity.x >= 0:
			linear_velocity.x = 25
		if linear_velocity.x > -25 && linear_velocity.x <= 0:
			linear_velocity.x = -25

func _on_Life_timeout():
	#killbub(false)
	#If bubble life times out it should die and not take out every bubble with it
	$pop.interpolate_property($Sprite, 'scale', $Sprite.get_scale(), Vector2(1.5,1.5) , pop_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$pop.start()
	$pop/pop_time.start()
	$Pop_Bubble.volume_db = -(randi()%20) - 10
		
	#queue_free()

func _on_pop_tween_completed( object, key ):
	$Pop_Bubble.play()
	$pop/pop_time.stop()
	$Sprite.hide()
	$CollisionShape2D.disabled = true


func _on_Pop_Bubble_finished():
	queue_free()

func _on_pop_time_timeout():
	if $Sprite.visible == true:
		$Sprite.visible = false
	else:
		$Sprite.visible = true

func _on_Float_timeout():
	gravity_scale = -1


func _on_AnimatedSprite_animation_finished():
	get_colliding_bodies()
	queue_free()

#pk, true if player popped the bubbles
func killbub(pk):
	if dying == false:
		dying = true
		$Area2D.monitorable = false
		for item in $Area2D.get_overlapping_bodies():
			if item.is_in_group("bubble") || item.is_in_group("enemy"):
				item.killbub(pk)
		$CollisionShape2D.disabled = true
		$Sprite.hide()
		linear_damp = 10
		#var anim = data.find_node("AnimatedSprite")AnimatedSprite
		#Bubble expand when killed
		$pop.interpolate_property($Sprite, 'scale', $Sprite.get_scale(), Vector2(1.5,1.5) , pop_time, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$pop.start()
		$pop.interpolate_property($Sprite, 'rotation_degrees', 0 , 360 , pop_time, Tween.TRANS_QUAD, Tween.EASE_OUT)	
		$Particles.emitting = true
		#$AnimatedSprite.play()
		
#func popbub():

#	if $pop/pop_time.is_stopped():
#		$pop/pop_time.start()
	
#	$pop.interpolate_property($Sprite, 'scale', $Sprite.get_scale(), Vector2(0.25,0.25) , pop_time,
#	Tween.TRANS_QUAD, Tween.EASE_OUT)
#	$pop.interpolate_property($Sprite, 'rotation_degrees', 0 , 360 , pop_time,
#	Tween.TRANS_QUAD, Tween.EASE_OUT)	
	
#	$pop.start()



#is player nearyb, ie pushing
func _on_Bubble_body_entered( body ):
	if body.is_in_group("player"):
		player_pushing = true

func _on_Bubble_body_exited( body ):
	if body.is_in_group("player"):
		player_pushing = false


