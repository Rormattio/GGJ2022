extends Node2D

signal hit

export var local_speed = 400 # How fast the player will move (pixels/sec).
var xspeed = 400

var screen_size # Size of the game window.
var total_life = 10
var life = total_life
var y_margin = 100
var normal_xpos = 0.0

func start(pos):
	position = pos
	show()
	$PlayerParticle/CollisionParticle.set_deferred("disabled", false)
	$PlayerWave/CollisionWave.set_deferred("disabled", true)
	$AnimatedSprite.animation = "particle"
	$AnimationSprite.play()

func change_state():
	if $AnimatedSprite.animation == "particle":
		$AnimatedSprite.animation = "wave"
		y_margin = screen_size.y/2
	elif $AnimatedSprite.animation == "wave":
		$AnimatedSprite.animation = "particle"
		position.y = screen_size.y/2
		y_margin = 100
	$AnimatedSprite.play()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		change_state()


# Called when the node enters the scene tree for the first time.
func _ready():
	#hide()
	screen_size = get_viewport_rect().size
	
func _process(delta):
	if $AnimatedSprite.animation == "particle":
		$PlayerParticle/CollisionParticle.set_deferred("disabled", false)
		$PlayerWave/CollisionWave.set_deferred("disabled", true)
	elif $AnimatedSprite.animation == "wave":
		$PlayerParticle/CollisionParticle.set_deferred("disabled", true)
		$PlayerWave/CollisionWave.set_deferred("disabled", false)

	
	## Player movement
	var direction = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1

	position += _compute_speed(direction.normalized()) * delta
	position.x = clamp(position.x, 0, screen_size.x)
	# hackish way to clamp below the screen
	position.y = clamp(position.y, y_margin, screen_size.y - y_margin)

	if life <= 0:
		game_over()


func _compute_speed(direction):
	normal_xpos = position.x / screen_size.x
	var xspeed = local_speed
	var yspeed = local_speed
	if direction.x > 0 and normal_xpos > 0.4:
		xspeed *= max(
			1.3*exp( -3*pow( (normal_xpos-0.4)/0.4, 3) ) - 0.3,
			0.0
		)
	elif direction.x < 0 and normal_xpos < 0.2:
		xspeed *= max(
			1.3*exp( -3*pow( (0.2-normal_xpos)/0.1, 3) ) - 0.3,
			0.0
		)
	
	return Vector2(xspeed*direction.x, yspeed*direction.y)


func _on_PlayerParticle_body_entered(body):
	emit_signal("hit")
	# Repair only possible in particle mode
	if "Repair" in body.name:
		life += 3
		life = clamp(life, 0, total_life)
	else:
		life -= 3
	# Make object disappear
	body.queue_free()


func _on_PlayerWave_body_entered(body):
	if body.is_in_group("taxis"):
		emit_signal("hit")
		life -= 1
		body.queue_free()
	# No effect if repair or asteroid 
	else:
		pass
	# Objects do not disappear in wave mode


func game_over():
	hide()


