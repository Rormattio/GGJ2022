extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var amplitude
#var frequency
var t = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += 1
	linear_velocity.x = linear_velocity.x * cos(2*PI*t) + linear_velocity.y * sin(2*PI*t)
	linear_velocity.y = linear_velocity.x * sin(2*PI*t) + linear_velocity.y * cos(2*PI*t)
