extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var frames_increase = true

func _ready():
	pass
	
func _process():
	pass

func _on_RigidBody2D_body_entered( body ):
	#BUG :- player is only recognised as entering body at certain angles
	if body.is_in_group("player"):
		Global_Vars.lives += 1
		queue_free()
