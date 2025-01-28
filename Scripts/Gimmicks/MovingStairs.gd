@tool
extends Node2D

@export var texture = preload("res://Graphics/Obstacles/Blocks/moving_block_2.png")
@export var length = 4
@export var timer = 1.0
var StairBlock = preload("res://Entities/Obstacles/Block.tscn")
@export_enum("right","left")var Horizontal_Direction = 0
@export_enum("up","down")var Vertical_Direction = 0
#@export var playsound = false
#@export var sound = preload("res://Audio/SFX/Gimmicks/Collapse.wav")

var player = []
var blocks = []
var buffer = 0
var activated = false
var blockmoverval = 0
var blockmove = 0

var vertdir = 1
var horizdir = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	if Vertical_Direction == 1:
		vertdir = -1
	if Horizontal_Direction == 1:
		horizdir = -1
	
	if !Engine.is_editor_hint():
		# texture overwrite
		$Block.rotation -= rotation
		$Block.texture = texture
		#$PlayerCheck.position.x = (length-1) * 16
		#$PlayerCheck.scale.x = length
		
	# duplicate block sprites until it matches the length

		for _i in range(length-1):
			var newBlock = $Block.duplicate()
			add_child(newBlock)
			blocks.append(newBlock)
			#$Block.position.x += $Block.texture.get_width()
			$Block.position.x += horizdir * 32
			$Block.texture = texture
		blocks.append($Block)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Engine.is_editor_hint():
		$Block_Editor.visible = false
		if activated == true:
			timer = timer-delta
			if timer < 0:
				blockmoverval = min((blockmoverval + (delta*0.5)),deg_to_rad(90))
				blockmove = sin(blockmoverval) * 32
				for i in range(blocks.size()):
					blocks[i].position.y = vertdir*(ceil(-blockmove * (i+1)))
					
		if scale.x < 0:
			pass


func _draw():
	if Engine.is_editor_hint():
		$Block_Editor.texture = texture
		for i in length:
			if i > 0:
				draw_texture($Block_Editor.texture,Vector2(($Block_Editor.texture.get_width()*(i*horizdir))-$Block_Editor.texture.get_width()/2,-$Block_Editor.texture.get_height()/2))
		for i in length:
			if Vertical_Direction == 0:
				draw_texture($Block_Editor.texture,Vector2(($Block_Editor.texture.get_width()*(i*horizdir))-$Block_Editor.texture.get_width()/2,-(($Block_Editor.texture.get_width()*(i+2))-$Block_Editor.texture.get_width()/2)),Color(1,1,1,0.45))
			if Vertical_Direction == 1:
				draw_texture($Block_Editor.texture,Vector2(($Block_Editor.texture.get_width()*(i*horizdir))-$Block_Editor.texture.get_width()/2,(($Block_Editor.texture.get_width()*(i+1))-$Block_Editor.texture.get_width()/2)),Color(1,1,1,0.45))


func _on_player_check_body_entered(body):
	
	activated = true


func _on_player_check_body_exited(body):
	pass


func _on_player_check_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	pass
