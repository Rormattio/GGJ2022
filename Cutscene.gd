extends Node2D


## Stolen from https://github.com/GDQuest/godot-open-rpg/tree/master/godot/src/dialogue
class_name DialogueAction

export (String, FILE, "*.json") var dialogue_file_path: String
signal dialogue_loaded(data)
var dialogue_dict
var _index_current = 0
var _len_dialogue_dict
var _intro_config_file = "res://assets/text/intro.json"
var _config_file = _intro_config_file

func _init_config(config_file):
	if config_file == _intro_config_file:
		$Tutoriel.show()
	_config_file = config_file

func _ready():
	dialogue_dict = load_dialogue(_config_file).values()
	_len_dialogue_dict = len(dialogue_dict)
	play_dialogue(dialogue_dict)
	$DialogueBG.color.a = 0.7


func load_dialogue(file_path) -> Dictionary:
	# Parses a JSON file and returns it as a dictionary
	var file = File.new()
	assert(file.file_exists(file_path))
	file.open(file_path, file.READ)
	var dialogue = parse_json(file.get_as_text())
	assert(dialogue.size() > 0)
	return dialogue

func play_dialogue(dialog_dict):
	$DialogueText.text = dialog_dict[_index_current].text
	$NameText.text = dialog_dict[_index_current].name
	if ($NameText.text == ""):
		$NameBox.hide() 
	else:
		$NameBox.show()
	
	$Background.texture = load("res://assets/"+dialog_dict[_index_current].background)
	var size = $Background.texture.get_size()
	var scale = Vector2((get_viewport_rect().size.x/size.x), (get_viewport_rect().size.y/size.y))
	$Background.scale = scale
	
	if dialog_dict[_index_current].expression != '':
		$CharacterImage.texture = load("res://assets/"+dialog_dict[_index_current].expression)
		if ($CharacterImage.texture):
			size = $CharacterImage.texture.get_size()
			scale = 1.4*get_viewport_rect().size.y/size.y
			$CharacterImage.scale = Vector2(scale, scale)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if _index_current == 0:
			$Tutoriel.hide()
		
		_index_current += 1
		if _index_current == _len_dialogue_dict:
			get_tree().change_scene("res://Transition.tscn")
			var level = get_parent().get_node("Cutscene")
			get_parent().remove_child(level)
			level.call_deferred("free")
		else:
			play_dialogue(dialogue_dict)
