extends Node2D

# Path to the next scene to transition to
#export(String, FILE, "*.tscn") var next_scene_path

# Reference to the _AnimationPlayer_ node
#onready var _anim_player := $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	# Plays the animation backward to fade in
	$VideoPlayer.play()
#	_anim_player.play("Fad")
#	yield(_anim_player, "animation_finished")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_VideoPlayer_finished():
#	_anim_player.play("Fade")
#	yield(_anim_player, "animation_finished")
	get_tree().change_scene("res://Run.tscn")
