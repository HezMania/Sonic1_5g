@tool
extends Node2D


# this moves back and forth based on a timer and speed, direction is angle based
@export_enum("Automatic", "Top Trigger", "Bottom Trigger",) var style = 0
@export var doubledoor = true
@export var distance = 64
@export var wait = 1.0
@export var speed = 7.0
@export var slide_player = true
var timer = wait
var extend = false

func _process(delta):
	# timer
	if !Engine.is_editor_hint():
		if style == 0:
			if timer > 0:
				timer -= delta
			else:
				timer = wait
				extend = !extend
	else:
		queue_redraw()

func _physics_process(delta):
	if !Engine.is_editor_hint():
		if !slide_player:
			$LeftDoor/Collision_Player.disabled = extend
		
		$LeftDoor.position = $LeftDoor.position.move_toward((Vector2(distance*int(extend),0)*$LeftDoor.scale),(speed*100)*delta)
		#print($LeftDoor/Crusher.texture.get_width())
		

func _draw():
	if Engine.is_editor_hint():
		var offset = Vector2(-$LeftDoor/Crusher.texture.get_width(),-$LeftDoor/Crusher.texture.get_height()/2)+$LeftDoor/Crusher.offset
		draw_texture($LeftDoor/Crusher.texture,(Vector2(distance,0)*$LeftDoor.scale)+offset,Color(1,0.5,0.5,0.5))
		if doubledoor:
			$PlayerCheck_Top/CollisionShape2D.scale.x = 2
			$PlayerCheck_Top/CollisionShape2D.position.x = -$LeftDoor/Crusher.texture.get_width()
			$PlayerCheck_Bottom/CollisionShape2D.scale.x = 2
			$PlayerCheck_Bottom/CollisionShape2D.position.x = -$LeftDoor/Crusher.texture.get_width()
		else:
			$PlayerCheck_Top/CollisionShape2D.scale.x = 1
			$PlayerCheck_Top/CollisionShape2D.position.x = -32
			$PlayerCheck_Bottom/CollisionShape2D.scale.x = 1
			$PlayerCheck_Bottom/CollisionShape2D.position.x = -32


func _on_player_check_top_body_entered(body):
	if style == 1:
		extend = false


func _on_player_check_top_body_exited(body):
	if style == 1:
		extend = true


func _on_player_check_bottom_body_entered(body):
	if style == 2:
		extend = true


func _on_player_check_bottom_body_exited(body):
	if style == 2:
		extend = false
