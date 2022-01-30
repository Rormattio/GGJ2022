extends RigidBody2D

class_name Taxi
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
	if t%100 == 0:
		linear_velocity.y = - linear_velocity.y


