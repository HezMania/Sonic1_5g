@tool
extends EnemyBase

const GRAVITY = 600
var direction = 1
var state = 0
var stateTimer = 0
var animTime = 0
@export var speed_normal = 60
var speed = speed_normal
@export var bounce = 200
var editorOffset = 1
@export var travelDistance = 512

var Particle = preload("res://Entities/Misc/GenericParticle.tscn")

func _ready():
	defaultMovement = false
	direction = -sign(scale.x)




func _physics_process(delta):
	if !Engine.is_editor_hint():# Dirction checks
		$Splats.scale.x = abs($Splats.scale.x)*-direction
		$FloorCheck.position.x = abs($FloorCheck.position.x)*direction
		$FloorCheck.force_raycast_update()
	
	# Edge check
	#if is_on_wall() or !$FloorCheck.is_colliding():
		#state = 1
		if is_on_wall():
			direction = -direction
	
	# Movement
		if state == 0:
		#this part is moving him left or right
			velocity.x = direction*speed
			animTime = fmod(animTime+delta*2,1)
			stateTimer = 0
		else: # Stationary
			velocity.x = 0
			animTime = 0
			stateTimer += delta
		
		# state timer check, if greater then 1 go back to normal
			if stateTimer >= 1:
				state = 0
				stateTimer = 0
				direction = -direction
	
	# Velocity movement
		set_velocity(velocity)
	# TODOConverter40 looks that snap in Godot 4.0 is float, not vector like in Godot 3 - previous value `Vector2.DOWN`
		set_up_direction(Vector2.UP)
		move_and_slide()
		velocity = velocity
	
		if velocity.y > 0:
			$Splats.play("falling")
	
		# Gravity
		if !is_on_floor():
			velocity.y += GRAVITY*delta
	
		if is_on_floor():
			velocity.y = -1*bounce
			$Splats.play("default")

func _draw():
	if Engine.is_editor_hint():
		null
