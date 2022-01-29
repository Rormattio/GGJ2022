extends Node

export(PackedScene) var obstacle_scene
export(PackedScene) var taxi_scene

var score

var speed = 400

func _ready():
	randomize()
	new_game()

func _on_Player_hit():
	print("hit")

#func game_over():
#	pass
#	#$ScoreTimer.stop()
#	$ObstacleTimer.stop()

func new_game():
	score = 0
	#$Player.start($StartPosition.position)
	#$StartTimer.start()
	$ObstacleTimer.start()
	$TaxiTimer.start()

func _on_ObstacleTimer_timeout():
	 # Choose a random location on Path2D.
	var obstacle_spawn_location = get_node("ObstaclePath/ObstacleSpawnLocation");
	obstacle_spawn_location.offset = randi()

	# Create a Obstacle instance and add it to the scene.
	var obstacle = obstacle_scene.instance()
	add_child(obstacle)

	# Set the mob's direction perpendicular to the path direction.
	var direction = obstacle_spawn_location.rotation + PI/2 #+ PI / 2

	# Set the mob's position to a random location.
	obstacle.position = obstacle_spawn_location.position

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	obstacle.rotation = direction

	# Choose the velocity.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	obstacle.linear_velocity = velocity.rotated(direction)

func _process(delta):
	$ProgressBar.value = (1.0*$Player.life/$Player.total_life)*100

#func _on_ScoreTimer_timeout():
#	score += 1


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
	var velocity = Vector2(rand_range(speed, speed + 100), 50)
	taxi.linear_velocity = velocity.rotated(direction)
