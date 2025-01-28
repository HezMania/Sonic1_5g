@tool
extends Node

@export var rotatingpaletteimage = preload("res://Graphics/Palettes/HPZwater.png")
@export var palspeed = 1
var rotatingpalette = preload("res://Shaders/RotatingPaletteSingle.tres")

var palrow = 0
@export var palette_length = 4
@export var palette_height = 5
@export_enum("Straight", "Pulse","PingPong") var rotationtype = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	rotatingpalette.set_shader_parameter("paletteTexture",rotatingpaletteimage)
	rotatingpalette.set_shader_parameter("amount",palette_length)
	rotatingpalette.set_shader_parameter("palRows",palette_height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		null
	var finalpalettenumber = 0
	palrow += (delta * palspeed)
	if rotationtype == 0:
		finalpalettenumber = wrapi(palrow,palette_height,1)
		rotatingpalette.set_shader_parameter("row",finalpalettenumber)

	if rotationtype == 1:
		finalpalettenumber = min((floor((abs(sin(palrow)*palette_height))) + 2),palette_height)
		rotatingpalette.set_shader_parameter("row",finalpalettenumber)

	if rotationtype == 2:
		var d = palette_height - 2
		var dx = palrow
		finalpalettenumber = 2 + abs(wrapi(dx, -d, d))
		rotatingpalette.set_shader_parameter("row",finalpalettenumber)
		
func _physics_process(_delta):
	pass
