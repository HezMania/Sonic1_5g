@tool
extends Node2D

@export var platformSprite = preload("res://Graphics/Obstacles/WZsawpole.png")
var EditorShape = preload("res://Graphics/Tiles/WorldsTiles/Platform.png")
@export var speedc = 60
@export var speedy = 10
var frame = 0
@export var length = 1
@export var sectionnumber = 3
@export var movingvariable = 1
var timing
var sawon

@export var endPosition = Vector2(256,0) # End travel point for platform
@export var speed = 1.0 # How fast to move
@export var offset = 0.0 # Initial offset, this can be used to offset the movements between other platforms # (float, 0.0, 3.1415)

@export var dropSlightly = true # Drop slightly when a player stands on top
@export var fallTimer = 0.0 # does the platform fall? 0 sets it to not fall

var offsetTimer = 0
var dropDistance = 0
var fallSpeed = 0
var fallActive = false
var doDrop = false
var platformDepth = 4

func _ready():
	# sprite related animations
	$Platform/MiddlePiece.texture = platformSprite
	$Platform/Chains.texture = platformSprite	
	$Platform/MiddlePiece.region_rect.size.x = length*32

	$Platform/Chains.position.x = length*16
	# constant linear velocity is a constant speed set in godot's physics

func _process(delta):
	if Engine.is_editor_hint():
		queue_redraw()
		# Offset timer for the editor to display
		offsetTimer = wrapf(offsetTimer+(delta*speed),0,PI*2)
	
	$Platform/MiddlePiece.region_rect.size.x = (16 * sectionnumber )
	$Platform/MiddlePiece.hframes = sectionnumber
	$Platform/Chains.vframes = sectionnumber 
	$Platform/Chains.hframes = sectionnumber
	$Platform/Chains.region_rect.size.x = (16 * sectionnumber )
	var ymoving = ((length*16)) + (sin(movingvariable) * ((length*16)))
	$Platform/Saw2WZ.position.y = ymoving +20
	$Platform/Chains.position.y = ymoving+12
	$Platform/MiddlePiece.region_rect.size.y = ymoving
	$Platform/Chains.position.x = 0
	$Platform/MiddlePiece.position.x = 0
	movingvariable += 0.001 * speedy
	
	frame = wrapf(frame-(delta*speedc/2),0,sectionnumber)
	$Platform/MiddlePiece.frame = (floor(frame))
	$Platform/Chains.frame = (floor(frame)*3)+1


func _physics_process(delta):
	if !Engine.is_editor_hint():
		# Sync the position up to tween between the start and end point based on level time
		var getPos = (endPosition*(cos((Global.globalTimer*speed)+offset)*0.5+0.5))
		# set platform to rounded position to prevent jittering
		if fallSpeed == 0:
			$Platform.position = (getPos+Vector2(0,dropDistance)).round()
		else:
			$Platform.translate(Vector2(0,fallSpeed))
		
		
		
		# drop
		
		if doDrop:
			# if a player collision was detected then activate fall if fall timer greater then 0
			if fallTimer > 0:
				fallActive = true
			# drop is drop slightly variable is active
			if dropSlightly:
				dropDistance += delta*16
		else:
			# return to normal
			dropDistance -= delta*16
		
		# clamp drop
		dropDistance = clamp(dropDistance,0,4)
		
		# falling
		if fallActive:
			fallTimer -= delta
			# if timer runs out start falling
			if fallTimer <= 0:
				fallSpeed += delta*20
			# clear if fall speed above a certain range to clear up resources
			if fallSpeed > 32:
				queue_free()
		
		# set doDrop to false for next loop, see platform child for collision
		doDrop = false


func _draw():
	if Engine.is_editor_hint():
		# Draw the platform positions for the editor
		if speed > 0 or endPosition != Vector2.ZERO:
			draw_texture(EditorShape,-EditorShape.get_size()/2,Color(1,1,1,0.25))
			draw_texture(EditorShape,endPosition-EditorShape.get_size()/2,Color(1,0.5,0.5,0.1))
			draw_texture(EditorShape,(endPosition*(cos(offsetTimer+offset)*0.5+0.5))-EditorShape.get_size()/2,Color.WHITE)
			draw_line(Vector2.ZERO,endPosition,Color.GREEN)
