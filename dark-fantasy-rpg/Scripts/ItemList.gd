extends Node

#n: String = "Empty", ss: int = 0, t: Texture2D = null, d: String = "How are you seeing this?", a: int=0, sc: String="res://Scenes/SItems/TestModel1.tscn"):

#ITEM DEFENITION
#Name
#Stack Size
#Texture Path
#Description
#Amount
#Model Path
var ITEM_ARRAY = [
	#ID 0
	Item.new(),
	#ID 1
	Item.new(
		"Test Square 1", 
		10, 
		"res://Textures/TestImage1.png",
		"Cube Schwartz", 
		1, 
		"res://Scenes/SItems/TestModel1.tscn"
	),
	#ID 2
	Item.new(
		"Test Cylinder 2", 
		27, 
		"res://Textures/TestImage2.png",
		"Natsumi Schwartz", 
		1, 
		"res://Scenes/SItems/TestModel2.tscn"
	),
	
	
	
	
	
]

func ADDITEM(ID, AMT):
	return Item.new(ITEM_ARRAY[ID].Name, ITEM_ARRAY[ID].StackSize, ITEM_ARRAY[ID].TextPath, ITEM_ARRAY[ID].Desc, AMT, ITEM_ARRAY[ID].ScenePath)
