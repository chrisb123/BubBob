extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	if linear_velocity.x > 0:
		$Fireballanim.flip_v = false
	else:
		$Fireballanim.flip_v = true

func _process():
	var item = $Area2d.get_overlapping_areas()
	print (item.get_name())
	var item2 = $Fireball.get_overlapping_areas()
	print (item2.get_name())

func _on_Area2D_area_entered( area ):
	if area.is_in_group("bubble_area"):
		area.get_parent()._on_Life_timeout()