#@tool
extends EnemyBase

var Projectile = preload("res://Entities/Enemies/Projectiles/CrabmeatProjectile.tscn")

const GRAVITY = 600
@export var direction = 1
@onready var origin = global_position
var state = 0
var stateTimer = 0
var animTime = 0
@export var speed_normal = 50
@export var speed_chasing = 50
@export var distance = 32
@export var shootingheight = 200
@export var shootingspeed = 100
var speed = speed_normal
var side = -1
var editorOffset = 1
var isFiring = 0
var fireTime = 0
var coolDown = 0
var fire = null
var fireL = null

var Particle = preload("res://Entities/Misc/GenericParticle.tscn")

func _ready():
	defaultMovement = false
	direction = -sign(scale.x)
	# clear fire if destroyed before shooting
	var _con = connect("destroyed",Callable(self,"clear_fire"))

func _physics_process(delta):
	# Direction checks
	$CrabmeatBody.scale.x = abs($CrabmeatBody.scale.x)*-direction
	$FloorCheck.position.x = abs($FloorCheck.position.x)*direction
	$FloorCheck.force_raycast_update()
	
	# Edge check
	if (is_on_wall() or !$FloorCheck.is_colliding()):
		state = 1
		
	# Movement
	if state == 0:
		velocity.x = direction*speed
		#animTime = fmod(animTime+delta*2,1)
		stateTimer = 0
		$CrabmeatBody.play("walking")
		if position.distance_to(origin+Vector2(distance*side,0).rotated(deg_to_rad(direction))) <= 1:
			state = 2
			side = -side
			
	else: # Stationary
		velocity.x = 0
		animTime = 0
		stateTimer += delta
		$CrabmeatBody.play("default")
		
		# state timer check, if greater then 1 go back to normal
		if stateTimer >= 1 and isFiring == 0:
			state = 0
			stateTimer = 0
			direction = -direction
		
		# crabmeat shoots his orbs
		if stateTimer >= 1 and isFiring == 1:
			$CrabmeatBody.play("shooting")
			
			if coolDown == 0:
				#fire first side
				fire = Projectile.instantiate()
				get_parent().add_child(fire)
				fireL = Projectile.instantiate()
				get_parent().add_child(fireL)
				# set position with offset
				#fire.global_position = global_position+Vector2(16*side,-5)
				fire.global_position = global_position+Vector2(16,-5)
				fireL.global_position = global_position+Vector2(-16,-5)
				fire.scale.x = side
				fireL.scale.x = side
				# create a weakref to verify projectile hasn't been deleted later
				var wrFire = weakref(fire)
				var wrFireL = weakref(fireL)
				# check that fire hasn't been deleted
				if wrFire.get_ref():
				# move projectile
					fire.get_node("projectile").play("fire")
					fire.hasGravity = true
					fire.velocity.y = -shootingheight
					fire.velocity.x += shootingspeed
				if wrFireL.get_ref():
				# move projectile
					fireL.get_node("projectile").play("fire")
					fireL.hasGravity = true
					fireL.velocity.y = -shootingheight
					fireL.velocity.x += -shootingspeed
				coolDown = 1
				#remove fire variable
				fire = null
		
			# crabmeat shoots his orbs
			if stateTimer >= 2 and isFiring == 1:
				state = 0
				stateTimer = 0
				direction = -direction
				coolDown = 0
				isFiring = 0
		
	
	# Velocity movement
	set_velocity(velocity)
	# TODOConverter40 looks that snap in Godot 4.0 is float, not vector like in Godot 3 - previous value `Vector2.DOWN`
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity
	
	# Gravity
	if !is_on_floor():
		velocity.y += GRAVITY*delta

func _on_player_check_body_entered(body):
	isFiring = 1

func clear_fire():
	if fire != null:
		fire.queue_free()
