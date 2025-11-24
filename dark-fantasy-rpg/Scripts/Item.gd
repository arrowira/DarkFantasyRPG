extends Resource
class_name Item
var Name : String
var StackSize : int
var Tex : Texture2D
var Desc : String
var Amt : int
var Pa
	
func _init(n: String = "Empty", ss: int = 0, t: Texture2D = null, d: String = "How are you seeing this?", a: int=0):
	Name = n
	StackSize = ss
	Tex = t
	Desc = d
	Amt = a
