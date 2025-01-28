@tool
extends Node2D

var ringyrings = preload("res://Entities/Items/Ring.tscn")
var fire = null



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!Engine.is_editor_hint()):
		if Input.is_key_pressed(KEY_K):
			print("clicked")
		if Input.is_key_pressed(KEY_C):
			fire = ringyrings.instantiate()
			add_child(fire)
			fire.global_position = global_position+Vector2(25,25)
