extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass
	

func _process(delta):
	move_and_collide(Vector2(1,-1))



func _on_Timer_timeout():
	queue_free()
