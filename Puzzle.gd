extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	yield(get_tree().create_timer(3),"timeout")
	get_parent()._title()
	queue_free()
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
