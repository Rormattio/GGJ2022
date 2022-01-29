extends Node2D

signal hit

export var local_speed = 400 # How fast the player will move (pixels/sec).

var screen_size # Size of the game window.

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
	elif $AnimatedSprite.animation == "wave":
		$AnimatedSprite.animation = "particle"
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
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * local_speed

	position += velocity * delta
#	position.x = clamp(position.x, 0, screen_size.x)
#	position.y = clamp(position.y, 0, screen_size.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PlayerParticle_body_entered(body):
	emit_signal("hit")


func _on_PlayerWave_body_entered(body):
	emit_signal("hit")
