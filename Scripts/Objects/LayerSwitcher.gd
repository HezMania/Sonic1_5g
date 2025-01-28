@tool
extends Area2D

var texture = load("res://Graphics/EditorUI/layer_switchers.png")
# layer settings, should be self explanatory
@export var size = Vector2(1,4)
@export_enum("Horizontal", "Vertical") var orientation = 0
@export var onlyOnFloor = false
@export_enum("Low", "High") var rightLayer = 0
@export_enum("Low", "High") var leftLayer = 0
@export_enum("Normal","High", "Low") var rightPriority = 0
@export_enum("Normal","High", "Low") var leftPriority = 0
@export var LongDistance = false
@export var PriorityOnly = false
@export var sizeROMconvert = 0

# list of player contacts
var playerList = []

func _ready():
	# set the mask scale to match the visual scale
	$Mask.scale = size
	# make invisible if not a hint
	if not Engine.is_editor_hint():
		visible = false

func _physics_process(_delta):
	# check for players
	if playerList.size() > 0:
		for i in playerList:
			# check that these variables exist in the player
			if "collissionLayer" in i and "ground" in i:
				# check if on the floor and if we're only check for grounded players
				if i.ground or not onlyOnFloor:
					match(orientation):
						0: #Horizontal
							if (i.global_position.x > global_position.x):
								i.collissionLayer = rightLayer
								i.z_index = rightPriority * 6
							else:
								i.collissionLayer = leftLayer
								i.z_index = leftPriority * 6
						1: #Vertical
							if (i.global_position.y > global_position.y):
								i.collissionLayer = rightLayer
								i.z_index = rightPriority * 6
							else:
								i.collissionLayer = leftLayer
								i.z_index = rightPriority * 6

func _process(_delta):
	# update for editor
	if Engine.is_editor_hint():
		$Mask.scale = size
		queue_redraw()

func _draw():
	# draw texture based on size, note this is purely for the editor
	for i in range(size.x):
		draw_texture_rect_region(texture,
		Rect2(Vector2((-8*size.x)+(i*8),-8*size.y),Vector2(8,16*size.y)),
		Rect2(Vector2(orientation*16,0),Vector2(8,16*size.y)))
	for i in range(size.x):
		for j in range(size.y):
			draw_texture_rect_region(texture,
			Rect2(Vector2((-8*size.x)+8+(i*16),(-8*size.y)+16*j),Vector2(8,8)),
			Rect2(Vector2(8+rightLayer*16,0),Vector2(8,8)))
			draw_texture_rect_region(texture,
			Rect2(Vector2((-8*size.x)+8+(i*16),(-8*size.y)+8+16*j),Vector2(8,8)),
			Rect2(Vector2(8+leftLayer*16,8),Vector2(8,8)))
	


func _on_layer_switcher_body_entered(body):
	if not Engine.is_editor_hint():
		if not playerList.has(body):
			playerList.append(body)


func _on_layer_switcher_body_exited(body):
	if not Engine.is_editor_hint():
		if playerList.has(body):
			playerList.erase(body)
