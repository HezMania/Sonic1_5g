@tool
extends Area2D

@export var vertical = 2
@export var horizontal = 2
@export var sinkspeed = 20
@export var RollAnimation = false
@export var Vertical = false


var players = []
var fall = false
var fallSpeed = 100
# Called when the node enters the scene tree for the first time.

signal player_entered
signal all_players_exited


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		$BoundaryVisable.visible = true
	else:
		$BoundaryVisable.visible = false
		pass
	$BoundaryVisable/Boundary_UL.position = Vector2(-8*horizontal,-8*vertical)
	$BoundaryVisable/Boundary_UR.position = Vector2(8*horizontal,-8*vertical)
	$BoundaryVisable/Boundary_BR.position = Vector2(8*horizontal,8*vertical)
	$BoundaryVisable/Boundary_BL.position = Vector2(-8*horizontal,8*vertical)
	$CheckPlayer/CollisionShape2D.scale = Vector2(2+(2*horizontal),2+(2*vertical))
	$CollisionShape2D.scale = Vector2(2+(2*horizontal),2+(2*vertical))
	
func _physics_process(_delta):
	# if any players are found in the array, if they're on the ground make them roll
	if players.size() > 0:
		for i in players:
			# ignore if player is dead
			if i.currentState == i.STATES.DIE:
				break
			# determine the direction of the arrow based on scale and rotation
			var gotin = 0
			var getDir = Vector2.RIGHT.rotated(global_rotation)
			
			if gotin == 0:
				i.movement.x = min(i.movement.x,100)
				gotin = 1
			
			if Vertical == true:
				pass
			else:
				if i.movement.y > 0:
					i.movement.y = sinkspeed
					i.ground = true
					
					if RollAnimation:
						i.animator.play("roll")
					else:
						i.animator.play("walk")
					i.groundSpeed = 10.0
					if i.inputs[i.INPUTS.ACTION] == 1 or i.inputs[i.INPUTS.ACTION3] == 1:
						i.movement.y += -300
						i.sfx[0].play()
						i.animator.play("roll")
						#i.animator.speed_scale = 1


func _on_body_entered(body):
	if !players.has(body):
		# emit signal for player touches (can be used for giant fans)
		if players.size() == 0:
			emit_signal("player_entered")
		players.append(body)
		#players.movement.x = players.movement.x*0.5


func _on_body_exited(body):
	if players.has(body):
		# check that player is not dead
		if body.currentState != body.STATES.DIE:
			body.set_state(body.STATES.NORMAL)
		players.erase(body)
		# emit signal for players exiting (can be used for giant fans)
		if players.size() == 0:
			emit_signal("all_players_exited")
