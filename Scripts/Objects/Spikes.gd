@tool
extends StaticBody2D

@export var shiftTimer = 0.00
@export var length = 1
@onready var start = position
@export var showanimation = false
@onready var shiftPoint = position+(Vector2.DOWN*scale.sign()).rotated(rotation)*32
var sunk = false
var sunkShift = 0

func _ready():
	
	if !is_equal_approx(shiftTimer,0):
		$ShiftTimer.start(abs(shiftTimer))
	else:
		set_physics_process(false)

func _physics_process(delta):
	position = lerp(start,shiftPoint,sunkShift)
	sunkShift += (1.0-int(sunk)*2.0)*delta*16
	sunkShift = clamp(sunkShift,0,1)
	$HitBox.disabled = !sunk
	
	
func _process(delta):
	#length
	if(Engine.is_editor_hint()):
		$Spike.region_rect.size.x = length*32
		$HitBox.scale.x = length
		$VisibleOnScreenEnabler2D.scale.x = length
		if showanimation == true:
			position = lerp(start,shiftPoint,sunkShift)
			sunkShift += (1.0-int(sunk)*2.0)*delta*16
			sunkShift = clamp(sunkShift,0,1)
		
	if(!Engine.is_editor_hint()):
		$Spike.region_rect.size.x = length*32
		$HitBox.scale.x = length
		$VisibleOnScreenEnabler2D.scale.x = length

# Collision check (this is where the player gets hurt, OW!)
func physics_collision(body, hitVector):
	if hitVector.is_equal_approx((Vector2.DOWN*scale.sign()).rotated(deg_to_rad(snapped(rotation_degrees,90)))):
		body.hit_player(global_position)
		return true


func _on_ShiftTimer_timeout():
	if $VisibleOnScreenEnabler2D.is_on_screen():
		$sfxSpikeShift.play()
	sunk = !sunk
