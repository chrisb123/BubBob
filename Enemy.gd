extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var _in_bubble = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func killbub():
	if _in_bubble:
		queue_free()


func _on_RigidBody2D_body_entered( body ):
	if body.is_in_group("bubble") && ! _in_bubble:
		$Bubble.show()
		_in_bubble = true
		$Enemy.scale = Vector2(0.33,0.33)
