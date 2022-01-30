extends Node2D

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_on_Button_pressed()

func _on_Button2_pressed():
	if Global.language == "fr":
		Global.language = "eng"
		$Button.text = "Start game"
		$Button2.text = "Language"
	else:
		Global.language = "fr"
		$Button.text = "Commencer le jeu"
		$Button2.text = "Langue"

func _on_Button_pressed():
	var cutscene_instance = preload("res://Cutscene.tscn").instance()
	if Global.language == "fr":
		cutscene_instance._init_config("res://assets/text/intro.json")
	else:
		cutscene_instance._init_config("res://assets/text_eng/intro.json")
	get_parent().add_child(cutscene_instance)
	var menu = get_parent().get_node("Menu")
	get_parent().remove_child(menu)
	menu.call_deferred("free")
