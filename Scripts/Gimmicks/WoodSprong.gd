@tool
extends StaticBody2D

var hitDirection = Vector2.UP
#@export var speed = [10,16]
@export var speed = 600
@export var springSound = preload("res://Audio/SFX/Gimmicks/Springs.wav")
@export var springScrewAnimation = false
@export var flipped = false

func _ready():
	if flipped == true:
		$WoodSprong.flip_h = true
	else:
		$WoodSprong.flip_h = false

func _process(_delta):
	if Engine.is_editor_hint():
		if flipped == true:
			$WoodSprong.flip_h = true
		else:
			$WoodSprong.flip_h = false	


func _on_area_2d_body_entered(body):
	# diagonal springs are pretty straightforward
	#body.movement = hitDirection.rotated(rotation).rotated(-body.rotation)*speed[type]*60
	if body.movement.y > 0:
		body.movement.y = -speed
		$WoodSprongAnimation.play("Springing")
		if (hitDirection.y < 0):
			body.set_state(body.STATES.AIR)
			# figure out the animation based on the players current animation
			var curAnim = "walk"
			match(body.animator.current_animation):
				"walk", "run", "peelOut":
					curAnim = body.animator.current_animation
				# if none of the animations match and speed is equal beyond the players top speed, set it to run (default is walk)
				_:
					if(abs(body.groundSpeed) >= min(6*60,body.top)):
						curAnim = "run"
			# play player animation
			if springScrewAnimation == true:
				body.animator.play("springScrew")
				body.animator.queue(curAnim)
			else:
				body.animator.play("spring")
				body.animator.queue(curAnim)
		Global.play_sound(springSound)
		# Disable pole grabs
		body.poleGrabID = self
