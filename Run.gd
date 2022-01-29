extends Node

export(PackedScene) var mob_scene
export var speed = 500 # How fast the player will move (pixels/sec).
var score

func _ready():
	randomize()

func _process(delta):
	pass
