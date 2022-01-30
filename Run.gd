extends Node

export(PackedScene) var obstacle_scene
export(PackedScene) var obstacle_small_scene
export(PackedScene) var taxi_scene
export(PackedScene) var character_prompt 
export(PackedScene) var repair_scene
var score
var spawn_dict
var speed = 400
var elapsed_time = 0
var start_pos
var screen_size

func _ready():
	randomize()
	new_game()

func _on_Player_hit():
	print("hit")

# contenu a mettre dans game_success, mais ici en attendant
func game_over():
#	pass
#	#$ScoreTimer.stop()
#	$ObstacleTimer.stop()
	var cutscene_instance = preload("res://Cutscene.tscn").instance()
	if Global.language == "fr":
		cutscene_instance._init_config("res://assets/text/game_over.json")
	else:
		cutscene_instance._init_config("res://assets/text_eng/game_over.json")
	get_parent().add_child(cutscene_instance)
	var run = get_parent().get_node("Run")
	get_parent().remove_child(run)
	run.call_deferred("free")

func new_game():
	score = 0
	screen_size = $Player.get_viewport_rect().size
	start_pos = Vector2(screen_size.x * 0.2, screen_size.y / 2)
	$Player.start(start_pos)
	#$StartTimer.start()
	#$ObstacleTimer.start()
	#$ObstacleSmallTimer.start()
	#$TaxiTimer.start()
	#$RepairTimer.start()
	$RunTimer.start()
	# Spawn ingame dialog
	if (Global.scene_index == 0):
		spawn_dict = load_spawn_dict("res://assets/levels/spawn_lvl_1.json")
	else:
		spawn_dict = load_spawn_dict("res://assets/levels/spawn_lvl_2_generated.json")
	if (Global.scene_index == 0):
		var character_dialog = character_prompt.instance()
		add_child(character_dialog)

func load_spawn_dict(file_path) -> Dictionary:
	# Load dictionnary describing ennemy spawning
	var file = File.new()
	assert(file.file_exists(file_path))
	file.open(file_path, file.READ)
	var spawn_dict = parse_json(file.get_as_text())
	assert(spawn_dict.size() > 0)
	return spawn_dict

func spawn_according_to(dict):
	var descriptors = dict.get(str(elapsed_time))
	if descriptors != null:
		for descriptor in descriptors:
			var x = descriptor.location[0]
			var y = descriptor.location[1]
			var type = descriptor.type
			var speed_x = descriptor.speed[0]
			var speed_y = descriptor.speed[1]
			spawn_at(type,x,y,speed_x,speed_y)

func spawn_at(type,x,y,speed_x,speed_y):
	var pos = Vector2(x,y)
	var direction = PI
	if type == "taxi":
		var taxi = taxi_scene.instance()
		add_child(taxi)
		taxi.position = pos
		var velocity = Vector2(speed_x, speed_y)
		taxi.linear_velocity = velocity.rotated(direction)
	elif type == "ast":
		var obstacle = obstacle_scene.instance()
		add_child(obstacle)
		obstacle.position = pos
		var velocity = Vector2(speed_x, speed_y)
		obstacle.linear_velocity = velocity.rotated(direction)
	elif type == "ast_s":
		var obstacle = obstacle_small_scene.instance()
		add_child(obstacle)
		obstacle.position = pos
		var velocity = Vector2(speed_x, speed_y)
		obstacle.linear_velocity = velocity.rotated(direction)
	elif type == "rep":
		var obstacle = repair_scene.instance()
		add_child(obstacle)
		obstacle.position = pos
		var velocity = Vector2(speed_x, speed_y)
		obstacle.linear_velocity = velocity.rotated(direction)
	else:
		print("Unknown type" + type)
		
func _process(delta):
	var life = $Player.life
	for i in range($Player.total_life):
		if (i<life):
			$HPBar.get_child(i).texture = load("res://assets/pixel_art/health_full.png")
		else:
			$HPBar.get_child(i).texture = load("res://assets/pixel_art/health_empty.png")
	if ($Player.life <= 0.0):
		game_over()

#func _on_ScoreTimer_timeout():
#	score += 1

func _on_RunTimer_timeout():
	var cutscene_instance = preload("res://Cutscene.tscn").instance()
	var path = "res://assets/text"
	if Global.language == "eng":
		path += "_eng"
	if(Global.scene_index == 0):
		cutscene_instance._init_config(path+"/scene1.json")
	elif(Global.scene_index == 1):
		cutscene_instance._init_config(path+"/scene2.json")
	Global.scene_index += 1
	get_parent().add_child(cutscene_instance)
	var run = get_parent().get_node("Run")
	get_parent().remove_child(run)
	run.call_deferred("free")
	
func _on_TaxiTimer_timeout():
	var taxi_spawn_location = get_node("ObstaclePath/ObstacleSpawnLocation");
	taxi_spawn_location.offset = randi()

	# Create a Obstacle instance and add it to the scene.
	var taxi = taxi_scene.instance()
	add_child(taxi)

	# Set the mob's direction perpendicular to the path direction.
	var direction = PI #+ PI / 2

	# Set the mob's position to a random location.
	taxi.position = taxi_spawn_location.position

	# Add some randomness to the direction.
#	direction += rand_range(-PI / 4, PI / 4)
	taxi.rotation = direction

	# Choose the velocity.
	var velocity = Vector2(rand_range(speed, speed + 300), 50)
	taxi.linear_velocity = velocity.rotated(direction)

func _on_RepairTimer_timeout():
	 # Choose a random location on Path2D.
	var repair_spawn_location = get_node("ObstaclePath/ObstacleSpawnLocation");
	repair_spawn_location.offset = randi()

	# Create a Obstacle instance and add it to the scene.
	var repair = repair_scene.instance()
	add_child(repair)

	# Set the mob's direction perpendicular to the path direction.
	var direction = repair_spawn_location.rotation + PI/2 #+ PI / 2

	# Set the mob's position to a random location.
	repair.position = repair_spawn_location.position

	# Add some randomness to the direction.
	#direction += rand_range(-PI / 4, PI / 4)
	repair.rotation = direction

	# Choose the velocity.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	repair.linear_velocity = velocity.rotated(direction)


func _on_Player_gyro():
	# move all current taxis outward _real_ fast
	# TODO: absolutely suboptimal,
	# find a way to apply this method to all members of group
	# taxis 
	var children = get_children()
	var taxis = Array()
	for child in children:
		if child is Taxi:
			taxis.append(child)
	for taxi in taxis:
		if taxi.position.y <$Player.position.y:
			taxi.linear_velocity.y -= $Player.position.y*2
		else:
			taxi.linear_velocity.y += $Player.position.y*2

func _on_TimeElapsed_timeout():
	elapsed_time += 1
	spawn_according_to(spawn_dict)

