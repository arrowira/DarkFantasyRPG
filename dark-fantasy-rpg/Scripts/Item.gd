extends Resource
class_name Item
var Name : String
var StackSize : int
var TextPath : String
var Desc : String
var Amt : int
var ScenePath : String
	
func _init(n: String = "Empty", ss: int = 0, t: String = "res://Textures/TestImage.png", d: String = "How are you seeing this?", a: int=0, sc: String="res://Scenes/SItems/TestModel1.tscn"):
	Name = n
	StackSize = ss
	TextPath = t
	Desc = d
	Amt = a
	ScenePath = sc
