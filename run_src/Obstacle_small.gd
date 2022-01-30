extends RigidBody2D

func _ready():
	$AnimatedSprite.playing = true
	var obstacle_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = obstacle_types[randi() % obstacle_types.size()]
