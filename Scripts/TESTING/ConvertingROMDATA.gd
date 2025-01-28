@tool
extends Node

var hextodec = "0x0A".hex_to_int()
var stringslashing = "blubb, blabb".split(",")
var stringslash2 = "blub,blube".split(",")

@export var Start_Ring_Conversion = false
@export var Start_Object_Conversion = false

#var file = 'res://TemporaryGraphics/EHZ2ringlayout.txt'

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Engine.is_editor_hint()):
		if Input.is_key_pressed(KEY_PAUSE):
			print(hextodec)
			print(stringslash2[1])
			var text = "line 1\nline 2"
			var lines = text.split("\n")
			for line in lines:
				print(line)
		if Input.is_key_pressed(KEY_PAUSE):
				var text = "hello world"
				var texthex = "01A0"
				var encoded = text.to_utf8_buffer().hex_encode()
				var decoded = texthex.hex_to_int()
				print(encoded)
				print(encoded.substr(4,2))
				print(decoded)
				
				
		if Start_Ring_Conversion == true:
				var file = 'res://TemporaryGraphics/EHZ2ringlayout.txt'
				var ringlayout = FileAccess.get_file_as_string(file)
				#var ringlayout = "01A0229802A82280037C32F003F041C003FC31AC04082198046822BC06BC32AC0700332C0913034F0937033B094C0318095002C8095002F00B0822E00BA822B00C680200C6802280C680250C6802780D3412C10DFC33AC0EC802500EE802600F080270F2802800F3003C00F480290F5003D00F7003E010B0036810CA03331100320113603331150036811CCA0CC11DAA0C011E8A0CC123003E8124A03B3125831B4126421981270117C127C01601280803A012B603B312D003E8158831281594214162002C0164C12C0166C03C8166C03F0166C0418166C0440166C0468169C12C016E002C0177C33AC181C12C018300168184A0133186002C01880012018A004018B6013318CC144018D00168191C144019B001E819CA01B31A0001A01A3601B3501E815802A01BB002971BE002801C102691C1103CF1C3003C040260"
				
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
				Start_Ring_Conversion = false
			
			
		if Start_Object_Conversion == true:
				var file = 'res://TemporaryGraphics/EHZ1objects.txt'
				var objectlayout = FileAccess.get_file_as_string(file)
				#var ringlayout = "01A0229802A82280037C32F003F041C003FC31AC04082198046822BC06BC32AC0700332C0913034F0937033B094C0318095002C8095002F00B0822E00BA822B00C680200C6802280C680250C6802780D3412C10DFC33AC0EC802500EE802600F080270F2802800F3003C00F480290F5003D00F7003E010B0036810CA03331100320113603331150036811CCA0CC11DAA0C011E8A0CC123003E8124A03B3125831B4126421981270117C127C01601280803A012B603B312D003E8158831281594214162002C0164C12C0166C03C8166C03F0166C0418166C0440166C0468169C12C016E002C0177C33AC181C12C018300168184A0133186002C01880012018A004018B6013318CC144018D00168191C144019B001E819CA01B31A0001A01A3601B3501E815802A01BB002971BE002801C102691C1103CF1C3003C040260"
				
				var decodringlayout = objectlayout.hex_decode()
				var ringlayoutsize = (objectlayout.length())/12
				#print(text_content)
				for i in ringlayoutsize:
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
					
					print("Object" + str(i))
					print("Object ID: " + str(tempid1))
					print("Subtype: " + str(temps1))
					print("Obj X Position: " + str(tempx1))
					print("Obj Y Position: " + str(tempy1))
					print("nybble: " + str(temptcon))
				Start_Object_Conversion = false
				
