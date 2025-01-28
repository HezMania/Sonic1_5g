@tool
extends Node2D

@export var overwritemode = false
@export var overwritebegin = false
@export_node_path("TileMapLayer")var tile
var getTiles = []
var testtile = TileMapLayer
var array = ["First", 2, 3, "Last"]
@export var LevelLength = 144.0
@export var TileSheetWidth = 16
@export var Collision_Solid = true
@export var Collision_Platform = false
@export var Collision_Blue = false
@export var Collision_Red = false
#put the asesprite stuff here
var LevelLayoutTesting = [

0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,2,3,2,3,2,3,4,5,6,3,2,3,4,5,6,7,4,5,6,7,5,8,8,9,2,3,2,4,5,5,6,4,6,2,3,4,5,6,7,4,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,4,5,6,7,3,7,3,4,10,0,11,12,13,14,15,16,17,0,0,0,18,19,0,20,21,22,23,24,25,16,26,27,16,28,29,30,30,16,31,31,16,31,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32,33,34,35,36,37,38,39,16,40,0,41,42,43,41,41,5,44,45,46,27,47,48,17,49,0,1,50,6,4,5,6,3,4,51,51,8,5,6,52,53,4,5,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32,0,49,54,0,55,56,10,57,58,34,59,60,61,0,0,0,62,6,7,4,7,6,63,55,36,9,64,16,31,26,27,65,66,26,67,27,11,68,69,42,18,19,
0,0,0,0,0,0,18,0,0,0,0,0,0,0,18,0,0,19,0,0,0,32,33,70,71,0,0,49,71,32,54,55,61,49,0,0,18,0,58,19,18,0,0,0,41,0,18,5,5,5,72,23,73,26,74,66,16,30,16,31,24,75,47,48,
0,18,19,0,0,0,76,77,78,0,0,79,18,80,76,77,29,76,67,67,67,67,28,81,61,0,0,55,82,32,61,0,79,70,10,80,76,77,81,76,76,67,67,67,67,27,47,16,0,0,6,83,66,65,66,16,73,14,84,85,53,52,86,52,
16,47,48,67,67,67,87,88,45,46,27,89,47,90,88,88,88,88,22,3,2,91,88,92,67,67,67,67,67,67,67,27,89,75,93,90,88,88,88,88,88,22,2,3,2,3,53,94,67,67,67,67,67,27,31,95,31,24,96,2,3,2,3,2,
85,53,86,3,2,3,2,3,2,3,2,52,86,53,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,85,86,52,53,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,86,52,53,85,53,3,2,3,2,3,



]

var LevelLayoutTestingxx = [0]
var FILENAME = 'res://TemporaryGraphics/introact1.txt'
@export var file = 'res://TemporaryGraphics/introact1.txt'
var levellayout = FileAccess.get_file_as_string(file)

# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.file_exists(FILENAME):
		var file = FileAccess.open(FILENAME, FileAccess.READ)
		print(levellayout)
	#this stuff right here does the converting below
	if overwritemode == true:		
		print( "startinglevelporting")
		for i in LevelLayoutTesting.size():
			var yposition = floor(i/LevelLength)
			var xposition = i - (yposition * LevelLength)
			var tileusedx = LevelLayoutTesting[i]%TileSheetWidth
			var tileusedy = floor(LevelLayoutTesting[i]/TileSheetWidth)
			if Collision_Solid == true:
				$TileMapLayer.set_cell(Vector2i(xposition,yposition),0,Vector2i(tileusedx,tileusedy),0)
			if Collision_Platform == true:
				$TileMapLayer2.set_cell(Vector2i(xposition,yposition),3,Vector2i(tileusedx,tileusedy),0)
			if Collision_Blue == true:
				$TileMapLayer3.set_cell(Vector2i(xposition,yposition),1,Vector2i(tileusedx,tileusedy),0)
			if Collision_Red == true:
				$TileMapLayer4.set_cell(Vector2i(xposition,yposition),2,Vector2i(tileusedx,tileusedy),0)

	pass
	
	
func _input(event):
	if(Engine.is_editor_hint()):
		if Input.is_key_pressed(KEY_K):
			print(array[0])
			print(array.size())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Engine.is_editor_hint()):
		var clicked_cell = $TileMapLayer.local_to_map($TileMapLayer.get_local_mouse_position())
		var data = $TileMapLayer.get_cell_tile_data(clicked_cell)
		var data2 = $TileMapLayer.get_cell_atlas_coords(clicked_cell)
		$TextTesting.text = str(clicked_cell) + str(data2)
		#potentially the bread and buttttteeerrr		
		#THIS IS IT RIGHT HERE!!! $TileMapLayer.set_cell(Vector2i(XLOCATION,YLOCATION),1,Vector2i(XTILEONATLAS,YTILEONATLAS),ALT-TILE)
		#$TileMapLayer.set_cell(Vector2i(2,2),0,Vector2i(5,4),0)
		if Input.is_key_pressed(KEY_K):
			print(LevelLayoutTesting[22])
			if FileAccess.file_exists(FILENAME):
				var file = FileAccess.open(FILENAME, FileAccess.READ)
				print(file)
		if Input.is_key_pressed(KEY_U):
				null
	if overwritebegin == true:
		print( levellayout)
		for i in LevelLayoutTesting.size():
			var yposition = floor(i/LevelLength)
			var xposition = i - (yposition * LevelLength)
			var tileusedx = LevelLayoutTesting[i]%TileSheetWidth
			var tileusedy = floor(LevelLayoutTesting[i]/TileSheetWidth)
			if Collision_Solid == true:
				$TileMapLayer.set_cell(Vector2i(xposition,yposition),0,Vector2i(tileusedx,tileusedy),0)
			if Collision_Platform == true:
				$TileMapLayer2.set_cell(Vector2i(xposition,yposition),3,Vector2i(tileusedx,tileusedy),0)
			if Collision_Blue == true:
				$TileMapLayer3.set_cell(Vector2i(xposition,yposition),1,Vector2i(tileusedx,tileusedy),0)
			if Collision_Red == true:
				$TileMapLayer4.set_cell(Vector2i(xposition,yposition),2,Vector2i(tileusedx,tileusedy),0)
		overwritebegin = false
		
	
		
func _physics_process(delta):
	if(!Engine.is_editor_hint()):
		if Input.is_key_pressed(KEY_K):
			print(LevelLayoutTesting[0])
			print(LevelLayoutTesting.size())
		for i in LevelLayoutTesting.size():
			var yposition = floor(i/LevelLength)
			var xposition = i - (yposition * LevelLength)
			var tileusedx = LevelLayoutTesting[i]%TileSheetWidth
			var tileusedy = floor(LevelLayoutTesting[i]/TileSheetWidth)
			$TileMapLayer.set_cell(Vector2i(xposition,yposition),0,Vector2i(tileusedx,0),0)
		
