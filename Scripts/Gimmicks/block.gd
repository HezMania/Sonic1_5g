extends Node2D

@export var texture = preload("res://Graphics/Obstacles/Blocks/moving_block_2.png")
var blockwidth = 32


# Called when the node enters the scene tree for the first time.
func _ready():
	blockwidth = $Block.texture.get_width()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Block.texture = texture
