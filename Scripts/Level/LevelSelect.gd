extends Node2D

@export var music = preload("res://Audio/Soundtrack/Sonic2OptionsNew.ogg")
@export var nextZone = load("res://Scene/Zones/BaseZone.tscn")
var selected = false

# character labels, the amount of labels in here determines the total amount of options, see the set character option at the end for settings
var characterLabels = ["Sonic and Tails", "Sonic", "Tails", "Knuckles", "Amy"]
# level labels, the amount of labels in here determines the total amount of options, see set level option at the end for settings
var levelLabels = [
	"Base Zone Act 1", 
	"Base Zone Act 2", 
	"Chunk Zone Act 1"]
# character id lines up with characterLabels
enum CHARACTER_ID { SONIC_AND_TAILS, SONIC, TAILS, KNUCKLES, AMY }
var characterID = CHARACTER_ID.SONIC_AND_TAILS
# level id lines up with levelLabels
var levelselectID = 0
var levelID = 0
var levelACT = 0
# Used to toggle visibility of character sprites (initialized in `_ready()`)
var characterSprites = []
# Used to avoid repeated detection of inputs with analog stick
var lastInput = Vector2.ZERO
# Attempting Level Select Variables
var LevelSelectNames = []
var ACTIVE = Color(0.8,0.8,0.0,1.0)
var INACTIVE = Color(1.0,1.0,1.0,1.0)
#background stuff
var BG_Timer = 0
var BG_Frame = 0

func _ready():
	if music != null:
			Global.music.stream = music
			Global.music.play()
	#Global.music.stream = music
	#Global.music.play()
	$UI/Labels/Control/Character.text = characterLabels[characterID]
	if nextZone != null:
		Global.nextZone = nextZone

	for child in $UI/Labels/CharacterOrigin.get_children():
		if child is Node2D or child is Sprite2D:
			characterSprites.append(child)
	assert(characterLabels.size() == characterSprites.size())
	assert(characterLabels.size() == CHARACTER_ID.size())

	for child in $UI/Labels/LevelSelect_Names.get_children():
		if child is Label:
			LevelSelectNames.append(child.text)
	#assert(characterLabels.size() == LevelSelectNames.size())
	#assert(characterLabels.size() == CHARACTER_ID.size())
	print(Global.main.wasPaused)

func _input(event):
	
	if !selected:
		var inputCue = Input.get_vector("gm_left","gm_right","gm_up","gm_down")
		inputCue.x = round(inputCue.x)
		inputCue.y = round(inputCue.y)
		if inputCue.x != lastInput.x and inputCue.x != 0:
			if inputCue.x < 0:
				null
			else: # inputCue.x > 0
				null
			$Switch.play()
		if inputCue.y != lastInput.y and inputCue.y != 0:
			if inputCue.y > 0:
				#levelID = wrapi(levelID+1,0,levelLabels.size())
				#levelselectID += 1
				levelselectID = wrapi(levelselectID+1,0,LevelSelectNames.size())
				null
			else: # inputCue.y < 0
				#levelID = wrapi(levelID-1,0,levelLabels.size())
				#levelselectID -= 1
				levelselectID = wrapi(levelselectID-1,0,LevelSelectNames.size())
				null
			$Switch.play()
		#Save previous input for next read
		lastInput = inputCue
		
		$UI/Labels/Control/Character.text = characterLabels[characterID]
		$UI/Labels/Control/Level.text = levelLabels[levelID]
		#$UI/Labels/LevelSelect_Names/Emerald_Hill.add_theme_color_override("font_color",ACTIVE)
		$UI/LevelSelectIcons/LevelSelectIconBorder/LevelSelectIcon.frame = 12 + levelselectID
		#Change color of selected level
		for child in $UI/Labels/LevelSelect_Names.get_children():
			child.add_theme_color_override("font_color",INACTIVE)
		$UI/Labels/LevelSelect_Names.get_child(levelselectID).add_theme_color_override("font_color",ACTIVE)
		
		
		# finish character select if start is pressed
		if event.is_action_pressed("gm_pause"):
			selected = true
			# set player 2 to none to prevent redundant code
			#Global.PlayerChar2 = Global.CHARACTERS.NONE
			
			# set the character
			#match(characterID):
				#CHARACTER_ID.SONIC_AND_TAILS:
					#Global.PlayerChar1 = Global.CHARACTERS.SONIC
					#Global.PlayerChar2 = Global.CHARACTERS.TAILS
				#CHARACTER_ID.SONIC:
					#Global.PlayerChar1 = Global.CHARACTERS.SONIC
				#CHARACTER_ID.TAILS:
					#Global.PlayerChar1 = Global.CHARACTERS.TAILS
				#CHARACTER_ID.KNUCKLES:
					#Global.PlayerChar1 = Global.CHARACTERS.KNUCKLES
				#CHARACTER_ID.AMY:
					#Global.PlayerChar1 = Global.CHARACTERS.AMY
					
			# set the level
			match(levelselectID):
				0: # Emerald Hill Zone Act 1
					Global.nextZone = load("res://Scene/ZonesS2/Emerald_Hill_01.tscn") # unnecessary since it's arleady set
				1: # Emerald Hill Zone Act 2
					Global.nextZone = load("res://Scene/ZonesS2/Emerald_Hill_02.tscn")
				2: # Using for Test right now
					Global.nextZone = load("res://Scene/ZonesS2/01_Zone_01.tscn")
				3: # Using for Test right now
					Global.nextZone = load("res://Scene/ZonesS2/01_Zone_02.tscn")
				4: # Secret Jungle Act 1
					Global.nextZone = load("res://Scene/ZonesS2/Secret_Jungle_01.tscn")
				5: # Secret Jungle Act 2
					Global.nextZone = load("res://Scene/ZonesS2/Secret_Jungle_02.tscn")
				6: # 03 Act 1
					Global.nextZone = load("res://Scene/ZonesS2/Sand_Shower_01.tscn")
				7: # 03 Act 2
					Global.nextZone = load("res://Scene/ZonesS2/Sand_Shower_02.tscn")
				8: # Metropolis Act 1
					Global.nextZone = load("res://Scene/ZonesS2/Metropolis_01.tscn")
				9: # Metropolis Act 2
					Global.nextZone = load("res://Scene/ZonesS2/Metropolis_02.tscn")
				10: # Metropolis Act 3
					Global.nextZone = load("res://Scene/ZonesS2/Metropolis_03.tscn")
				11: # Sky Fortress Act 1
					Global.nextZone = load("res://Scene/ZonesS2/Sky_Fortress_01.tscn")
				12: # Sky Fortress Act 2
					Global.nextZone = load("res://Scene/ZonesS2/Sky_Fortress_02.tscn")
				13: # Hill Top Act 1
					Global.nextZone = load("res://Scene/ZonesS2/Hill_Top_01.tscn")
				14: # Hill Top Act 2
					Global.nextZone = load("res://Scene/ZonesS2/Hill_Top_02.tscn")
				15: # Hidden Palace Act 1
					Global.nextZone = load("res://Scene/ZonesS2/Hidden_Palace_01.tscn")
				16: # Hidden Palace Act 2
					Global.nextZone = load("res://Scene/ZonesS2/Hidden_Palace_02.tscn")
				17: # 09 act 1
					Global.nextZone = load("res://Scene/ZonesS2/09_Zone_01.tscn")
				18: # 09 act 2
					Global.nextZone = load("res://Scene/ZonesS2/09_Zone_02.tscn")
				19: # Oil Ocean Act 1
					Global.nextZone = load("res://Scene/ZonesS2/Oil_Ocean_01.tscn")
				20: # Oil Ocean Act 2
					Global.nextZone = load("res://Scene/ZonesS2/Oil_Ocean_02.tscn")
				21: # Mystic Cave Act 1
					Global.nextZone = load("res://Scene/ZonesS2/Mystic_Cave_01.tscn")
				22: # Mystic Cave Act 2
					Global.nextZone = load("res://Scene/ZonesS2/Mystic_Cave_02.tscn")
				23: # Casino Night Act 1
					Global.nextZone = load("res://Scene/ZonesS2/Casino_Night_01.tscn")
				24: # Casino Night Act 2
					Global.nextZone = load("res://Scene/ZonesS2/Casino_Nigh_02.tscn")
				25: # Chemical Plant Act 1
					Global.nextZone = load("res://Scene/ZonesS2/Chemical_Plant_01.tscn")
				26: # Chemical Plant Act 2
					Global.nextZone = load("res://Scene/ZonesS2/Chemical_Plant_02.tscn")
				27: # Death Egg Act 1
					Global.nextZone = load("res://Scene/ZonesS2/Death_Egg_01.tscn")
				28: # Death Egg Act 2
					Global.nextZone = load("res://Scene/ZonesS2/Death_Egg_02.tscn")
				29: # Aquatic Ruin Act 1
					Global.nextZone = load("res://Scene/ZonesS2/Aquatic_Ruin_01.tscn")
				30: # Aquatic Ruin Act 2
					Global.nextZone = load("res://Scene/ZonesS2/Aquatic_Ruin_02.tscn")
				31: # Sky Chase Act 1
					Global.nextZone = load("res://Scene/ZonesS2/Genocide_City_01.tscn")
				32: # Sky Chase Act 2
					Global.nextZone = load("res://Scene/ZonesS2/Genocide_City_02.tscn")
			Global.main.change_scene_to_file(Global.nextZone,"FadeOut","FadeOut",1)
func _physics_process(delta):
	BG_Timer += delta
		
	if BG_Timer > 3:
		if BG_Frame < 3:
			BG_Frame += 0.1
	if BG_Timer < 3:
		if BG_Frame > 0:
			BG_Frame -= 0.1
	if BG_Timer > 6:
		BG_Timer = 0
			
	for child in $UI/Background_Sonic2.get_children():
		if child is Sprite2D:
			child.frame = BG_Frame
	#get_tree().set_group("UI/Sonic2BG", "frame", 3)
	$UI/Labels/TextTesting.text = str(LevelSelectNames[levelselectID])
	#changing color of level select text
	#$UI/Labels/LevelSelect_Names.get_child(levelselectID).add_theme_color_override("font_color",ACTIVE)
	
		
	
