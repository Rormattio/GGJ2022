extends Node2D

export(PackedScene) var obstacle_scene
var score

func _ready():
	randomize()
	new_game()

func _on_Player_hit():
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()

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
	#direction += rand_range(-PI / 4, PI / 4)
	obstacle.rotation = direction

	# Choose the velocity.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	obstacle.linear_velocity = velocity.rotated(direction)


func _on_StartTimer_timeout():
	$ObstacleTimer.start()
	$ScoreTimer.start()


func _on_ScoreTimer_timeout():
	score += 1
