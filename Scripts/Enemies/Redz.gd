extends EnemyBase

const GRAVITY = 600
var direction = 1
var state = 0
var stateTimer = 0
var animTime = 0
@export var speed_normal = 20
@export var speed_chasing = 20
var speed = speed_normal



var Particle = preload("res://Entities/Misc/GenericParticle.tscn")

func _ready():
	defaultMovement = false
	direction = -sign(scale.x)

func _physics_process(delta):
	# Dirction checks
	$Redz.scale.x = abs($Redz.scale.x)*-direction
	$FloorCheck.position.x = abs($FloorCheck.position.x)*direction
	$FloorCheck.force_raycast_update()
	
	# Edge check
	if (is_on_wall() or !$FloorCheck.is_colliding()) and stateTimer == 0:
		state = 1
	
	# Movement
	if state == 0:
		velocity.x = direction*speed
		animTime = fmod(animTime+delta*2,1)
		stateTimer = 0
		$Redz.animation = "walking"
	else: # Stationary
		velocity.x = 0
		animTime = 0
		stateTimer += delta
		$Redz.animation = "default"
		
		# state timer check, if greater then 1 go back to normal
		if stateTimer >= 1:
			state = 0
			stateTimer = -30
			direction = -direction
	
	# Velocity movement
	set_velocity(velocity)
	# TODOConverter40 looks that snap in Godot 4.0 is float, not vector like in Godot 3 - previous value `Vector2.DOWN`
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity
	
	# Gravity
	if !is_on_floor():
		velocity.y += GRAVITY*delta
