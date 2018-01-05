extends Node

export (PackedScene) var Title
export (PackedScene) var Level1
export (PackedScene) var Player
export (PackedScene) var GUI
export (PackedScene) var Bubble
export (PackedScene) var Enemy
var title
var player
var gui
var score = 0
var max_enemies = 5

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	Global_Vars.score = 0
	Global_Vars.lives = Global_Vars.start_lives
	title = Title.instance()
	add_child(title)
	title.connect("start",self,"_start")
	#var level1 = Level1.instance()
	#add_child(level1)
	#var player = Player.instance()
	#add_child(player)
	#var gui = GUI.instance()
	#add_child(gui)


func _process(delta):
	# If lives gets to zero, delete all enemies and player, restart
	if Global_Vars.lives == 0:
		var enemies = get_tree().get_nodes_in_group("enemy")
		for enemy in enemies:
			enemy.queue_free()
		var bubbles = get_tree().get_nodes_in_group("bubble")
		for bubble in bubbles:
			bubble.queue_free()
		var players = get_tree().get_nodes_in_group("player")
		for player in players:
			player.queue_free()
		$Enemy.stop()
		_ready()

func _start():
	remove_child(title)
	var level1 = Level1.instance()
	add_child(level1)
	var player = Player.instance()
	player.position = Vector2(140,180)
	add_child(player)
	player.connect("fired",self,"_fired")
	gui = GUI.instance()
	add_child(gui)
	$Enemy.start()
	
	
func _fired(facing):
	#print("fired ",facing)
	var bubble = Bubble.instance()
	bubble.facing = facing
	add_child(bubble)
	var pos = $Player.position
	pos.x += 25 * facing
	pos.y -= 5
	bubble.position = pos
	var anim = bubble.find_node("AnimatedSprite")
	#anim.connect("animation_finished",self,"popped")
	
#func popped():
	#score += 1
	#gui.get_child(0).text = str(score)

func _on_Enemy_timeout():
	var enemy_count = get_tree().get_nodes_in_group("enemy").size()
	if enemy_count < max_enemies:
		randomize()
		var enemy = Enemy.instance()
		enemy.position = Vector2(randi()%500+100,randi()%500+100)
		add_child(enemy)
		#remove_child(enemy)
