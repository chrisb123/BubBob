extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var frames_increase = true

func _ready():
	pass
	
func _process():
	pass

func _on_Area2D_body_entered( body ):
	#BUG :- player is only recognised as entering body at certain angles
	#Solution Use Area2d so its not affected by physics
	if body.is_in_group("player"):
		Global_Vars.lives += 1
		queue_free()
