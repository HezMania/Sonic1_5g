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
	null
