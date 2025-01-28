@tool
extends StaticBody2D

@export var platformSprite = preload("res://Graphics/Gimmicks/ConveyorBelt.png")
@export var speed = 60
var frame = 0
@export var length = 1
@export var sectionnumber = 3
@export var reverse = false
@export var middlesection = false
@export var middlesectionart = preload("res://Graphics/Gimmicks/ConveyorBelt_Middle.png")

func _ready():
	# sprite related animations
	$MiddlePiece.texture = platformSprite
	$LeftCog.texture = platformSprite
	$RightCog.texture = platformSprite
	$MiddleCogs/MiddleCog.texture = middlesectionart
	$MiddleCogs/MiddleCog2.texture = middlesectionart
	$MiddleCogs/MiddleCog3.texture = middlesectionart
	$MiddleCogs/MiddleCog4.texture = middlesectionart
	
	$MiddlePiece.region_rect.size.x = length*32
	$LeftCog.position.x = -length*16
	$RightCog.position.x = length*16
	$CollisionShape2D.scale.x = length+1
	# constant linear velocity is a constant speed set in godot's physics
	if reverse == false:
		constant_linear_velocity.x = speed		
	else:
		constant_linear_velocity.x = -speed

func _process(delta):
	if Engine.is_editor_hint():
		$MiddlePiece.region_rect.size.x = length*32
		$MiddlePiece.region_rect.size.y = (96 * sectionnumber )
		$LeftCog.position.x = -length*16
		$RightCog.position.x = length*16
		$CollisionShape2D.scale.x = length+1
		$MiddlePiece.vframes = sectionnumber * 3
		$LeftCog.vframes = sectionnumber * 3
		$RightCog.vframes = sectionnumber * 3
		$LeftCog.hframes = 1
		$RightCog.hframes = 1
		$LeftCog.region_rect.size.y = (96 * sectionnumber )
		$RightCog.region_rect.size.y = (96 * sectionnumber )
	
	if middlesectionart != null:
		$MiddleCogs.visible = true
	else:
			$MiddleCogs.visible = false
			
	if length > 7:
		$MiddleCogs/MiddleCog.position.x = -length*2.75
		$MiddleCogs/MiddleCog2.position.x = length*2.75
		$MiddleCogs/MiddleCog3.position.x = length*8.75
		$MiddleCogs/MiddleCog4.position.x = -length*8.75
		$MiddleCogs/MiddleCog.visible = true
		$MiddleCogs/MiddleCog2.visible = true
		$MiddleCogs/MiddleCog3.visible = true
		$MiddleCogs/MiddleCog4.visible = true
	if length <= 7 and length > 5:
		$MiddleCogs/MiddleCog.position.x = -length*4.75
		$MiddleCogs/MiddleCog2.position.x = length*4.75
		$MiddleCogs/MiddleCog.visible = true
		$MiddleCogs/MiddleCog2.visible = true
		$MiddleCogs/MiddleCog3.visible = false
		$MiddleCogs/MiddleCog4.visible = false
	if length <= 5:
		$MiddleCogs/MiddleCog.position.x = 0
		$MiddleCogs/MiddleCog2.position.x = 0
		$MiddleCogs/MiddleCog.visible = true
		$MiddleCogs/MiddleCog2.visible = false
		$MiddleCogs/MiddleCog3.visible = false
		$MiddleCogs/MiddleCog4.visible = false
	
	$MiddleCogs/MiddleCog.hframes = sectionnumber
	$MiddleCogs/MiddleCog2.hframes = sectionnumber
	$MiddleCogs/MiddleCog3.hframes = sectionnumber
	$MiddleCogs/MiddleCog4.hframes = sectionnumber
	if reverse == false:
		frame = wrapf(frame+(delta*speed/2),0,sectionnumber)
		
	else:
		frame = wrapf(frame-(delta*speed/2),0,sectionnumber)
	$LeftCog.frame = (floor(frame)*3)
	$MiddlePiece.frame = (floor(frame)*3)+2
	$RightCog.frame = (floor(frame)*3)+1
	$MiddleCogs/MiddleCog.frame = (floor(frame))
	$MiddleCogs/MiddleCog2.frame = (floor(frame))
	$MiddleCogs/MiddleCog3.frame = (floor(frame))
	$MiddleCogs/MiddleCog4.frame = (floor(frame))
	
	if middlesection == null:
		reverse = true
