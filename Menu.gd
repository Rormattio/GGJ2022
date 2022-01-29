extends Node2D


func _on_Button_pressed():
	var cutscene_instance = preload("res://Cutscene.tscn").instance()
	cutscene_instance._init_config("res://assets/text/intro.json")
	get_parent().add_child(cutscene_instance)
	var menu = get_parent().get_node("Menu")
	get_parent().remove_child(menu)
	menu.call_deferred("free")
