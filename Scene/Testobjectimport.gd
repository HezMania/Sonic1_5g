@tool
extends Node2D

var ringyrings = preload("res://Entities/Items/Ring.tscn")
var monitoritem = preload("res://Entities/Items/Monitor.tscn")
var springitem = preload("res://Entities/Gimmicks/Spring.tscn")
var spikeitem = preload("res://Entities/Hazards/Spikes.tscn")
var pathswapperitem = preload("res://Entities/MainObjects/LayerSwitcher.tscn")
var platformitem = preload("res://Entities/Obstacles/Platform.tscn")
var starpostitem = preload("res://Entities/Items/Checkpoint.tscn")

#Item Inventory here
var fire = null
var monitory = null
var springy = null
var spikey = null
var ppathswappery = null
var movingplatformy = null
var starpposty = null
#Item Inventory here
@export var FirstTimeFix = false

@export var Start_Ring_Conversion = false
@export var Start_Monitor_Conversion = false
@export var Start_Spring_Conversion = false
@export var Start_Spikes_Conversion = false
@export var Start_PathSwapper_Conversion = false
@export var Start_MovPlatform_Conversion = false
@export var StarPost_Conversion = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Engine.is_editor_hint()):
		var file = 'res://TemporaryGraphics/MTZ1objects.txt'
		if Input.is_key_pressed(KEY_K):
			print("clicked")
			print($RINGS.get_owner())
		if Input.is_key_pressed(KEY_PAUSE):
			#fire.set_owner($RINGS.get_owner())
			#monitory.set_owner($MONITORS.get_owner())
			#springy.set_owner($SPRINGS.get_owner())
			#spikey.set_owner($SPIKES.get_owner())
			fire = ringyrings.instantiate()
			$RINGS.add_child(fire)
			fire.global_position = global_position+Vector2(25+delta*10,25+delta*20)
			monitory = monitoritem.instantiate()
			$MONITORS.add_child(monitory)
			monitory.global_position = global_position+Vector2(25+delta*10,25+delta*20)
			springy = springitem.instantiate()
			$SPRINGS.add_child(springy)
			springy.global_position = global_position+Vector2(25+delta*10,25+delta*20)
			spikey = spikeitem.instantiate()
			$SPIKES.add_child(spikey)
			spikey.global_position = global_position+Vector2(10+delta*10,10+delta*20)
			ppathswappery = pathswapperitem.instantiate()
			$PATHSWAPPERS.add_child(ppathswappery)
			ppathswappery.global_position = global_position+Vector2(10+delta*10,10+delta*20)
			movingplatformy = platformitem.instantiate()
			$MOVINGPLATFORMS.add_child(movingplatformy)
			movingplatformy.global_position = global_position+Vector2(10+delta*10,10+delta*20)
			starpposty = starpostitem.instantiate()
			$MOVINGPLATFORMS.add_child(starpposty)
			starpposty.global_position = global_position+Vector2(10+delta*10,10+delta*20)

		if Start_Ring_Conversion == true:

				var ringlayout = FileAccess.get_file_as_string(file)
				var decodringlayout = ringlayout.hex_decode()
				var ringlayoutsize = (ringlayout.length())/8
				#print(text_content)
				for i in ringlayoutsize:
					var tempx1 = ((ringlayout.substr(i*8,4)))
					var tempy1 = ((ringlayout.substr((i*8)+5,3)))
					var tempt1 = ((ringlayout.substr((i*8)+4,1)))
					var tempxcon = tempx1.hex_to_int()
					var tempycon = tempy1.hex_to_int()
					var temptcon = tempt1.hex_to_int()
					
					print("Ring" + str(i))
					print("Ring X Position: " + str(tempxcon))
					print("Ring Y Position: " + str(tempycon))
					print("nybble: " + str(temptcon))
					
					fire.set_owner($RINGS.get_owner())
					fire = ringyrings.instantiate()
					$RINGS.add_child(fire)
					fire.global_position = global_position+Vector2(tempxcon,tempycon)
					
					if temptcon > 0 and temptcon < 9:
						for j in temptcon:
							fire.set_owner($RINGS.get_owner())
							fire = ringyrings.instantiate()
							$RINGS.add_child(fire)
							fire.global_position = global_position+Vector2(tempxcon + (24*(j+1)),tempycon)
							
					if temptcon > 8 and temptcon < 16:
						for j in (temptcon-8):
							fire.set_owner($RINGS.get_owner())
							fire = ringyrings.instantiate()
							$RINGS.add_child(fire)
							fire.global_position = global_position+Vector2(tempxcon,tempycon + (24*(j+1)))
					
				Start_Ring_Conversion = false
		
		if Start_Monitor_Conversion == true:

				var objectlayout = FileAccess.get_file_as_string(file)
				var decodringlayout = objectlayout.hex_decode()
				var objectlayoutsize = (objectlayout.length())/12
				#print(text_content)
				for i in objectlayoutsize:
					var tempid1 = ((objectlayout.substr((i*12)+8,2)))
					var tempx1 = ((objectlayout.substr(i*12,4)))
					var tempy1 = ((objectlayout.substr((i*12)+5,3)))
					var tempt1 = ((objectlayout.substr((i*12)+4,1)))
					var temps1 = ((objectlayout.substr((i*12)+10,2)))
					var tempxcon = tempx1.hex_to_int()
					var tempycon = tempy1.hex_to_int()
					var temptcon = tempt1.hex_to_int()
					var tempidcon = tempid1.hex_to_int()
					var tempscon = temps1.hex_to_int()
					var monitoricon = int(temps1)
					
					if tempid1 == "26":
						print("Object" + str(i))
						print("Object ID: " + str(tempid1))
						print("Subtype: " + str(temps1))
						print("Obj X Position: " + str(tempx1))
						print("Obj Y Position: " + str(tempy1))
						print("nybble: " + str(temptcon))
						print("monitoricon: " + str(monitoricon))
					
					#Monitors
					if tempid1 == "26":
						monitory.set_owner($MONITORS.get_owner())
						monitory = monitoritem.instantiate()
						$MONITORS.add_child(monitory)
						monitory.global_position = global_position+Vector2(tempxcon,tempycon)
						if monitoricon == 1:
							monitory.item = 10
						if monitoricon == 4:
							monitory.item = 0
						if monitoricon == 5:
							monitory.item = 1
						if monitoricon == 6:
							monitory.item = 3
						if monitoricon == 7:
							monitory.item = 2
						if monitoricon == 8:
							monitory.item = 7
						
				Start_Monitor_Conversion = false
				
		if Start_Spring_Conversion == true:

			var objectlayout = FileAccess.get_file_as_string(file)
			var decodringlayout = objectlayout.hex_decode()
			var objectlayoutsize = (objectlayout.length())/12
			#print(text_content)
			for i in objectlayoutsize:
				var tempid1 = ((objectlayout.substr((i*12)+8,2)))
				var tempx1 = ((objectlayout.substr(i*12,4)))
				var tempy1 = ((objectlayout.substr((i*12)+5,3)))
				var tempt1 = ((objectlayout.substr((i*12)+4,1)))
				var temps1 = ((objectlayout.substr((i*12)+10,2)))
				var tempxcon = tempx1.hex_to_int()
				var tempycon = tempy1.hex_to_int()
				var temptcon = tempt1.hex_to_int()
				var tempidcon = tempid1.hex_to_int()
				var tempscon = temps1.hex_to_int()
				var springcolor = int(tempscon) % 4
				var springtype = ceil(int(tempscon)/12)
				var springspin = int(tempscon) % 1
				
				if tempid1 == "41":
					print("Spring" + str(i))
					print("Spring ID: " + str(tempid1))
					print("Spring Subtype: " + str(temps1))
					print("Spring X Position: " + str(tempx1))
					print("Spring Y Position: " + str(tempy1))
					print("Spring nybble: " + str(temptcon))
					print(tempscon)
					print(str(springcolor))
					print("springType: " + str(springtype))
					print("springspin: " + str(springspin))
				
				#Springs
				if tempid1 == "41":
					springy.set_owner($SPRINGS.get_owner())
					springy = springitem.instantiate()
					$SPRINGS.add_child(springy)
					springy.global_position = global_position+Vector2(tempxcon,tempycon)
					springy.springScrewAnimation = springspin
					
					#color
					if springcolor < 2:
						springy.type = 1
						#springy.springDirection = 0
						#springy.springScrewAnimation = 0
					else:
						pass
					if temptcon == 0 or temptcon == 4:
						if springtype == 0:
							springy.springDirection = 0
						if springtype == 1:
							springy.springDirection = 2
						if springtype == 2:
							springy.springDirection = 1
						if springtype == 3:
							springy.springDirection = 6
						if springtype == 4:
							springy.springDirection = 4
					if temptcon == 2 or temptcon == 6:
						if springtype == 0:
							springy.springDirection = 0+1
						if springtype == 1:
							springy.springDirection = 2+1
						if springtype == 2:
							springy.springDirection = 1+1
						if springtype == 3:
							springy.springDirection = 6+1
						if springtype == 4:
							springy.springDirection = 4+1

			Start_Spring_Conversion = false

		if Start_Spikes_Conversion == true:

			var objectlayout = FileAccess.get_file_as_string(file)
			var decodringlayout = objectlayout.hex_decode()
			var objectlayoutsize = (objectlayout.length())/12
			#print(text_content)
			for i in objectlayoutsize:
				var tempid1 = ((objectlayout.substr((i*12)+8,2)))
				var tempx1 = ((objectlayout.substr(i*12,4)))
				var tempy1 = ((objectlayout.substr((i*12)+5,3)))
				var tempt1 = ((objectlayout.substr((i*12)+4,1)))
				var temps1 = ((objectlayout.substr((i*12)+10,2)))
				var tempxcon = tempx1.hex_to_int()
				var tempycon = tempy1.hex_to_int()
				var temptcon = tempt1.hex_to_int()
				var tempidcon = tempid1.hex_to_int()
				var tempscon = temps1.hex_to_int()
				var spikemovement = int(tempscon) % 4
				var spiketype = ceil(int(tempscon)/12)
				var springspin = int(tempscon) % 1
				
				if tempid1 == "36":
					print("Spring" + str(i))
					print("Spring ID: " + str(tempid1))
					print("Spring Subtype: " + str(temps1))
					print("Spring X Position: " + str(tempx1))
					print("Spring Y Position: " + str(tempy1))
					print("Spring nybble: " + str(temptcon))
					print(tempscon)
					print(str(spikemovement))
					print("spiketype: " + str(spiketype))
					print("springspin: " + str(springspin))
				
				#Springs
				if tempid1 == "36":
					spikey.set_owner($SPIKES.get_owner())
					spikey = spikeitem.instantiate()
					$SPIKES.add_child(spikey)
					spikey.global_position = global_position+Vector2(tempxcon,tempycon)
					spikey.length = spiketype + 1
					
					if temptcon == 4:
						spikey.rotation_degrees = rotation_degrees+180


			Start_Spikes_Conversion = false

		if Start_PathSwapper_Conversion == true:

			var objectlayout = FileAccess.get_file_as_string(file)
			var decodringlayout = objectlayout.hex_decode()
			var objectlayoutsize = (objectlayout.length())/12
			#print(text_content)
			for i in objectlayoutsize:
				var tempid1 = ((objectlayout.substr((i*12)+8,2)))
				var tempx1 = ((objectlayout.substr(i*12,4)))
				var tempy1 = ((objectlayout.substr((i*12)+5,3)))
				var tempt1 = ((objectlayout.substr((i*12)+4,1)))
				var temps1 = ((objectlayout.substr((i*12)+10,2)))
				var tempxcon = tempx1.hex_to_int()
				var tempycon = tempy1.hex_to_int()
				var temptcon = tempt1.hex_to_int()
				var tempidcon = tempid1.hex_to_int()
				var tempscon = temps1.hex_to_int()
				var pathswappursize = (int(tempscon) % 4)
				var pathswappurdirection = int(tempscon) % 8
				var pathswappurtype = ceil(int(tempscon)/12)
				var pathswappurleftuppapth = int(tempscon) % 32
				var pathswappurrightdownpath = int(tempscon) % 16
				var pathswappurleftuppriority = int(tempscon) % 128
				var pathswappurrightdownpriority = int(tempscon) % 64
				
				if tempid1 == "03":
					print("pathswappur" + str(i))
					print("pathswappur ID: " + str(tempid1))
					print("pathswappur Subtype: " + str(temps1))
					print("pathswappur X Position: " + str(tempx1))
					print("pathswappur Y Position: " + str(tempy1))
					print("pathswappur nybble: " + str(temptcon))
					print("pathswappurType: " + str(pathswappurtype))
					print("XXXXXXXX)")
					print("pathswappursize: " + str(pathswappursize))
				
				#pathswappurs
				if tempid1 == "03":
					ppathswappery.set_owner($PATHSWAPPERS.get_owner())
					ppathswappery = pathswapperitem.instantiate()
					$PATHSWAPPERS.add_child(ppathswappery)
					ppathswappery.global_position = global_position+Vector2(tempxcon,tempycon)
					
					
					#direction setting
					if pathswappurdirection >= 4:
						ppathswappery.orientation = 1
						
					if pathswappurleftuppapth < 16:
						ppathswappery.leftLayer = 1
						
					if pathswappurrightdownpath < 8:
						ppathswappery.rightLayer = 1
					
					if pathswappurrightdownpriority >= 32:
						ppathswappery.rightPriority = 1
						
					if pathswappurleftuppriority >= 64:
						ppathswappery.leftPriority = 1
						
					#size
					if ppathswappery.orientation == 0:
						if pathswappursize == 0:
							ppathswappery.size = Vector2(1,4)
						if pathswappursize == 1:
							ppathswappery.size = Vector2(1,8)
						if pathswappursize == 2:
							ppathswappery.size = Vector2(1,16)
						if pathswappursize == 3:
							ppathswappery.size = Vector2(1,32)
					if ppathswappery.orientation == 1:
						if pathswappursize == 0:
							ppathswappery.size = Vector2(4,1)
						if pathswappursize == 1:
							ppathswappery.size = Vector2(8,1)
						if pathswappursize == 2:
							ppathswappery.size = Vector2(16,1)
						if pathswappursize == 3:
							ppathswappery.size = Vector2(32,1)
					
			Start_PathSwapper_Conversion = false
			
		if Start_MovPlatform_Conversion == true:

			var objectlayout = FileAccess.get_file_as_string(file)
			var decodringlayout = objectlayout.hex_decode()
			var objectlayoutsize = (objectlayout.length())/12
			#print(text_content)
			for i in objectlayoutsize:
				var tempid1 = ((objectlayout.substr((i*12)+8,2)))
				var tempx1 = ((objectlayout.substr(i*12,4)))
				var tempy1 = ((objectlayout.substr((i*12)+5,3)))
				var tempt1 = ((objectlayout.substr((i*12)+4,1)))
				var temps1 = ((objectlayout.substr((i*12)+10,2)))
				var tempxcon = tempx1.hex_to_int()
				var tempycon = tempy1.hex_to_int()
				var temptcon = tempt1.hex_to_int()
				var tempidcon = tempid1.hex_to_int()
				var tempscon = temps1.hex_to_int()
				var platfurmocolor = int(tempscon) % 4
				var platfurmotype = ceil(int(tempscon)/12)
				var platfurmospin = int(tempscon) % 1
				
				if tempid1 == "18":
					print("platfurmo" + str(i))
					print("platfurmo ID: " + str(tempid1))
					print("platfurmo Subtype: " + str(temps1))
					print("platfurmo X Position: " + str(tempx1))
					print("platfurmo Y Position: " + str(tempy1))
					print("platfurmo nybble: " + str(temptcon))
					print(tempscon)
					print(str(platfurmocolor))
					print("platfurmoType: " + str(platfurmotype))
					print("platfurmospin: " + str(platfurmospin))
				
				#platfurmos
				if tempid1 == "18":
					movingplatformy.set_owner($MOVINGPLATFORMS.get_owner())
					movingplatformy = platformitem.instantiate()
					$MOVINGPLATFORMS.add_child(movingplatformy)
					movingplatformy.global_position = global_position+Vector2(tempxcon,tempycon)
					
					if tempscon == 0:
						movingplatformy.endPosition = Vector2(0,0)
						movingplatformy.speed = 0
						movingplatformy.dropSlightly = 1
						movingplatformy.fallTimer = 0
						
					if tempscon == 1:
						movingplatformy.endPosition = Vector2(128,0)
						movingplatformy.speed = 1
						movingplatformy.dropSlightly = 1
						movingplatformy.fallTimer = 0
						movingplatformy.position.x = tempxcon-64
					if tempscon == 2:
						movingplatformy.endPosition = Vector2(0,-128)
						movingplatformy.speed = 1
						movingplatformy.dropSlightly = 1
						movingplatformy.fallTimer = 0
						movingplatformy.position.y = tempycon+64
					if tempscon == 3:
						movingplatformy.endPosition = Vector2(0,0)
						movingplatformy.speed = 1
						movingplatformy.dropSlightly = 1
						movingplatformy.fallTimer = 1
					if tempscon == 4:
						movingplatformy.endPosition = Vector2(128,0)
						movingplatformy.speed = 1
						movingplatformy.dropSlightly = 1
						movingplatformy.fallTimer = 0
						movingplatformy.offset = 180
						movingplatformy.position.x = tempxcon+64
					if tempscon == 5:
						movingplatformy.endPosition = Vector2(128,0)
						movingplatformy.speed = 1
						movingplatformy.dropSlightly = 1
						movingplatformy.fallTimer = 0
						movingplatformy.offset = 180
						movingplatformy.position.x = tempxcon-64
					if tempscon == 6:
						movingplatformy.endPosition = Vector2(0,-128)
						movingplatformy.speed = 1
						movingplatformy.dropSlightly = 1
						movingplatformy.fallTimer = 0
						movingplatformy.offset = 180
						movingplatformy.position.y = tempycon+64
					if tempscon == 154:
						movingplatformy.endPosition = Vector2(0,-64)
						movingplatformy.speed = 1
						movingplatformy.dropSlightly = 1
						movingplatformy.fallTimer = 0
						movingplatformy.offset = 0
						movingplatformy.position.y = tempycon+32
					if tempscon == 155:
						movingplatformy.endPosition = Vector2(0,-64)
						movingplatformy.speed = 1
						movingplatformy.dropSlightly = 1
						movingplatformy.fallTimer = 0
						movingplatformy.offset = 180
						movingplatformy.position.y = tempycon+32
					
					

			Start_MovPlatform_Conversion = false

		if StarPost_Conversion == true:

			var objectlayout = FileAccess.get_file_as_string(file)
			var decodringlayout = objectlayout.hex_decode()
			var objectlayoutsize = (objectlayout.length())/12
			#print(text_content)
			for i in objectlayoutsize:
				var tempid1 = ((objectlayout.substr((i*12)+8,2)))
				var tempx1 = ((objectlayout.substr(i*12,4)))
				var tempy1 = ((objectlayout.substr((i*12)+5,3)))
				var tempt1 = ((objectlayout.substr((i*12)+4,1)))
				var temps1 = ((objectlayout.substr((i*12)+10,2)))
				var tempxcon = tempx1.hex_to_int()
				var tempycon = tempy1.hex_to_int()
				var temptcon = tempt1.hex_to_int()
				var tempidcon = tempid1.hex_to_int()
				var tempscon = temps1.hex_to_int()
				var StrPstmovement = int(tempscon) % 4
				var StrPsttype = ceil(int(tempscon)/12)
				var StrPstspin = int(tempscon) % 1
				
				if tempid1 == "79":
					print("StrPst" + str(i))
					print("StrPst ID: " + str(tempid1))
					print("StrPst Subtype: " + str(temps1))
					print("StrPst X Position: " + str(tempx1))
					print("StrPst Y Position: " + str(tempy1))
					print("StrPst nybble: " + str(temptcon))
					print(tempscon)
					print(str(StrPstmovement))
					print("StrPsttype: " + str(StrPsttype))
					print("StrPstspin: " + str(StrPstspin))
				
				#StrPsts
				if tempid1 == "79":
					starpposty.set_owner($STARPOSTS.get_owner())
					starpposty = starpostitem.instantiate()
					$STARPOSTS.add_child(starpposty)
					starpposty.global_position = global_position+Vector2(tempxcon,tempycon)


			StarPost_Conversion = false
