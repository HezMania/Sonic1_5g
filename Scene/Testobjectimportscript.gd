@tool
extends EditorScript

var fire = null
var scene = get_scene()
var ringyring = preload("res://Entities/Items/Ring.tscn")

func _run():
	var children = [get_editor_interface().get_selection().get_selected_nodes()]
	var testring = get_editor_interface().get_selection().get_selected_nodes()
	print(children)
	
	var spatial = Node2D.new()
	spatial.set_owner(scene.get_owner())
	scene.add_child(spatial)
	print(scene.get_owner())
