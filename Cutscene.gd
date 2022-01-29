extends Node2D


## Stolen from https://github.com/GDQuest/godot-open-rpg/tree/master/godot/src/dialogue
class_name DialogueAction

export (String, FILE, "*.json") var dialogue_file_path: String
signal dialogue_loaded(data)
var dialogue_dict
var _index_current = 0
var _len_dialogue_dict


func _ready():
	dialogue_dict = load_dialogue("res://assets/text/intro.json").values()
	_len_dialogue_dict = len(dialogue_dict)
	play_dialogue(dialogue_dict)

func _process(delta):
	print(_index_current)
	play_dialogue(dialogue_dict)

func load_dialogue(file_path) -> Dictionary:
	# Parses a JSON file and returns it as a dictionary
	var file = File.new()
	assert(file.file_exists(file_path))
	file.open(file_path, file.READ)
	var dialogue = parse_json(file.get_as_text())
	assert(dialogue.size() > 0)
	return dialogue

func play_dialogue(dialog_dict):
	$DialogueBox.text = dialog_dict[_index_current].text

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_index_current += 1
		if _index_current == _len_dialogue_dict:
			get_tree().change_scene("res://Run.tscn")
