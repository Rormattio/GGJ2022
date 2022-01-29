extends Node2D

export(PackedScene) var mob_scene
export var speed = 400 # How fast the player will move (pixels/sec).
var score

func _ready():
	randomize()

func _process(delta):
	pass
#	move_local_x(-speed*delta)
