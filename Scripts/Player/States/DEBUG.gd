extends PlayerState

var activated = true
var pasteobject

var MonitorDB = preload("res://Entities/Items/Monitor.tscn")
var RingDB = preload("res://Entities/Items/Ring.tscn")


func _ready():
	invulnerability = true # ironic
	

func _process(_delta):
	if activated:
		# hide shield
		var lastAnim = parent.animator.current_animation
		parent.shieldSprite.visible = false
		invulnerability = true # ironic
		parent.translate = true
		#parent.visible = false
		parent.debugSprite.visible = true
		parent.sprite.visible = false
		# set movement to 0
		parent.movement = Vector2.ZERO
		#activated = false
		parent.animator.play(lastAnim)
		# enable control again		
		if parent.inputs[parent.INPUTS.YINPUT] != 0:
			parent.movement.y = 512 * parent.inputs[parent.INPUTS.YINPUT]
		if parent.inputs[parent.INPUTS.XINPUT] != 0:
			parent.movement.x = 512 * parent.inputs[parent.INPUTS.XINPUT]
		if parent.inputs[parent.INPUTS.ACTION2] == 1:
			parent.set_state(parent.STATES.AIR)
			
		if parent.inputs[parent.INPUTS.ACTION3] == 1:
			pasteobject = MonitorDB.instantiate()
			add_child(pasteobject)
			pasteobject.global_position = Vector2(parent.position.x,parent.position.y)

func state_exit():
	parent.movement.y = 0
	parent.movement.x = 0
	parent.translate = false
	parent.visible = true
	parent.sprite.visible = true
	parent.debugSprite.visible = false
	if parent.shield != parent.SHIELDS.NONE:
		parent.shieldSprite.visible = true
	activated = true
	parent.movement.y = 0
	parent.movement.x = 0
