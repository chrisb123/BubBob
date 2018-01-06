extends AnimatedSprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var jumping

func _ready():

	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):

	if animation == "running" && $Running.is_playing() == false:
		$Running.play()
	if animation != "running":
		$Running.stop()
		
	if animation == "jump" && $Jump.is_playing() == false && jumping == false:
		jumping = true
		$Jump.play()
	if animation != "jump":
		jumping = false




func _on_Jump_finished():
	$Jump.stop()
