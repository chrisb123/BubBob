extends Node

func _ready():
	yield(get_tree().create_timer(3),"timeout")
	get_parent()._title()
	queue_free()
