extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (int) var facing
var velocity = 500
var dying = false

func _ready():
	linear_velocity.x = velocity * facing
	#print(facing)

func _process(delta):
	if linear_velocity.x < 25 && linear_velocity.x >= 0:
		linear_velocity.x = 25
	if linear_velocity.x > -25 && linear_velocity.x <= 0:
		linear_velocity.x = -25

func _on_Life_timeout():
	queue_free()

func _on_Float_timeout():
	gravity_scale = -1


func _on_AnimatedSprite_animation_finished():
	get_colliding_bodies()
	queue_free()

func killbub():
	if dying == false:
		dying = true
		$Area2D.monitorable = false
		for item in $Area2D.get_overlapping_bodies():
			if item.is_in_group("bubble") || item.is_in_group("enemy"):
				item.killbub()
		$CollisionShape2D.disabled = true
		$Sprite.hide()
		linear_damp = 10
		#var anim = data.find_node("AnimatedSprite")
		$AnimatedSprite.play()
		