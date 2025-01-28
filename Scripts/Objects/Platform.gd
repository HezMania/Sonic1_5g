@tool
extends Node2D

@export var platformSprite = preload("res://Graphics/Tiles/WorldsTiles/Platform.png")
@export var endPosition = Vector2(256,0) # End travel point for platform
@export var speed = 1.0 # How fast to move
@export var offset = 0.0 # Initial offset, this can be used to offset the movements between other platforms # (float, 0.0, 3.1415)

@export var dropSlightly = true # Drop slightly when a player stands on top
@export var fallTimer = 0.0 # does the platform fall? 0 sets it to not fall

@export var SIN_COS = false
@export var lift = false
@export var liftTimer = 0.0 # does the platform fall? 0 sets it to not fall

var offsetTimer = 0
var dropDistance = 0
var fallSpeed = 0
var fallActive = false
var liftActive = false
var doDrop = false
var platformDepth = 4

var editorX = 0
var editorY = 0

var tempmoving = 0.0

func _ready():
	# Change platform shape
	$Platform/Shape3D.shape.size.x = platformSprite.get_size().x
	$Platform/Shape3D.shape.size.y = platformDepth/2.0
	$Platform/Shape3D.position.y = -(platformSprite.get_size().y/2.0)+(platformDepth/2.0)
	if !Engine.is_editor_hint():
		# Change platform sprite texture
		$Platform/Sprite2D.texture = platformSprite
	else:
		offsetTimer = 0
	

func _process(delta):
	if Engine.is_editor_hint():
		$Platform/Shape3D.shape.size.x = platformSprite.get_size().x
		$Platform/Shape3D.shape.size.y = platformDepth/2.0
		$Platform/Shape3D.position.y = -(platformSprite.get_size().y/2.0)+(platformDepth/2.0)
		queue_redraw()
		# Offset timer for the editor to display
		if lift == true:
			offsetTimer = wrapf(offsetTimer+(delta*speed),0,PI)
		else:
			offsetTimer = wrapf(offsetTimer+(delta*speed),0,PI*2)

func _physics_process(delta):
	if !Engine.is_editor_hint():
		#additional seperation for circular motion
		if lift == false:
			editorX = ((cos((Global.globalTimer*speed)+offset)*0.5+0.5) * endPosition.x)
			if SIN_COS == true:
				editorY = ((sin((Global.globalTimer*speed)+offset)*0.5+0.5) * endPosition.y)
			else:
				editorY = ((cos((Global.globalTimer*speed)+offset)*0.5+0.5) * endPosition.y)
				
		if lift == true:
			if liftTimer <= 0:
				print(tempmoving)
				if tempmoving < PI:
					tempmoving += delta * speed
			editorX = ((cos((tempmoving))*0.5+0.5) * endPosition.x)
			if SIN_COS == true:
				editorY = ((sin((tempmoving))*0.5+0.5) * endPosition.y)
			else:
				editorY = ((cos((tempmoving))*0.5+0.5) * endPosition.y)
		# Sync the position up to tween between the start and end point based on level time
		#var getPos = (endPosition*(cos((Global.globalTimer*speed)+offset)*0.5+0.5))
		var getPos = (Vector2(editorX,editorY))
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
			if lift == true:
				liftActive = true
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
				
		if liftActive:
			liftTimer -= delta
			
		
		# set doDrop to false for next loop, see platform child for collision
		doDrop = false


func _draw():
	if Engine.is_editor_hint():
		# Draw the platform positions for the editor
		if speed > 0 or endPosition != Vector2.ZERO:
			draw_texture(platformSprite,-platformSprite.get_size()/2,Color(1,1,1,0.25))
			draw_texture(platformSprite,endPosition-platformSprite.get_size()/2,Color(1,0.5,0.5,0.1))
			#draw_texture(platformSprite,(endPosition*(cos(offsetTimer+offset)*0.5+0.5))-platformSprite.get_size()/2,Color.WHITE)
			editorX = ((cos(offsetTimer+offset)*0.5+0.5) * endPosition.x) - (platformSprite.get_size().x/2)
			if SIN_COS == true:
				editorY = ((sin(offsetTimer+offset)*0.5+0.5) * endPosition.y) - (platformSprite.get_size().y/2)
				draw_arc(Vector2((endPosition.x * 0.5),(endPosition.y * 0.5)),(endPosition.x*0.5),deg_to_rad(0),deg_to_rad(180),1500,Color.GREEN,1)
				draw_arc(Vector2((endPosition.x * 0.5),(endPosition.y * 0.5)),(endPosition.x*0.5),deg_to_rad(180),deg_to_rad(360),1500,Color.RED,1)
				draw_circle(Vector2((endPosition.x * 0.5),(endPosition.y * 0.5)),(endPosition.x*0.5) + platformSprite.get_size().x/2,Color(1,0.5,0.5,0.05))
			else:
				editorY = ((cos(offsetTimer+offset)*0.5+0.5) * endPosition.y) - (platformSprite.get_size().y/2)
				draw_line(Vector2.ZERO,endPosition,Color.GREEN)
			#print((cos(offsetTimer+offset)*0.5+0.5) * endPosition.x)
			draw_texture(platformSprite,Vector2(editorX,editorY),Color.WHITE)
			#draw_arc(Vector2.ZERO,25,1,550,1500,Color(0.5,0,1,0.5),3)
			#draw_circle(Vector2.ZERO,50 + 1,Color(1,0.5,0.5,0.05))
