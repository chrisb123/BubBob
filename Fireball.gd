extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	#if linear_velocity.x > 0:
	#	$Fireballanim.flip_v = false
	#else:
	#	$Fireballanim.flip_v = true
	pass
	
func _on_Area2D_body_entered( body ):
	if body.is_in_group("tiles"):
		#print("tilemap hit")
		_die()
	#if body.is_in_group("player"):
	#	print("hit")

		
func _die():
	linear_velocity = Vector2(0,0)
	#$Area2D.monitoring = false #not needed and causes error messages
	#$Area2D.monitorable = false
	$Area2D/CollisionShape2D.disabled = true
	if Global_Vars.Osys != "HTML5":
		$Particles2D.emitting = true
	$Explosion.playing = true
	$Fireballanim.visible = false
		
func _on_Area2D_area_entered( area ):
	if area.is_in_group("bubble_area"):
		area.get_parent()._on_Life_timeout()

func _on_Explosion_finished():
	queue_free()
