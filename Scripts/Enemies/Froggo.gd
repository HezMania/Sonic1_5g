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
var actionset = 0

var Particle = preload("res://Entities/Misc/GenericParticle.tscn")

func _ready():
	defaultMovement = false
	direction = -sign(scale.x)




func _physics_process(delta):
	$Froggo_body.scale.x = abs($Froggo_body.scale.x)*-direction
	$FloorCheck.position.x = abs($FloorCheck.position.x)*direction
	$FloorCheck.force_raycast_update()
	
	# Edge check
	#if is_on_wall() or !$FloorCheck.is_colliding():
		#state = 1
	if is_on_wall():
		direction = -direction
	
	# Movement
	if actionset > 0 and actionset != 5:
		#this part is moving him left or right
		velocity.x = direction*speed
		stateTimer = 0
	else:
		stateTimer += delta
		velocity.x = 0
		$Froggo_body.play("default")
		
		if stateTimer >= 2:
			state = 0
			stateTimer = 0
			#actionset = 1
			if actionset == 5:
				direction = -direction
				actionset = 1
			else:
				actionset = 1
	
	# Velocity movement
	set_velocity(velocity)
	# TODOConverter40 looks that snap in Godot 4.0 is float, not vector like in Godot 3 - previous value `Vector2.DOWN`
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity
	
	#if velocity.y > 1:
	#	$Froggo_body.play("falling")
	
		# Gravity
	if !is_on_floor():
		velocity.y += GRAVITY*delta
	
	if is_on_floor() and actionset > 0 and actionset != 5 :
		$Froggo_body.play("jumping")
		if actionset == 4:
			actionset = 5
		if actionset == 3:
			velocity.y = -1.5*bounce
			actionset += 1
		if actionset < 3:
			velocity.y = -1*bounce
			actionset += 1
