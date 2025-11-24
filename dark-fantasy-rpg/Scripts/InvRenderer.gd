extends Node3D

var InvSlot = preload("res://Scenes/InventorySlot.tscn")
var IScript
var R = false

var OInv
var Open = false

func _physics_process(delta: float) -> void:
	#has to ready after the inventory script is loaded so put it a frame after
	if(R == false):
		IScript = get_node("/root/Node3D/Player/InventoryManager")
		OInv = IScript.Inv
		var Pos = Vector2(0, 0)
		var Dist = 64
		for i in range(OInv.size()):
			if(Pos.x == 8*64):
				Pos.y+=64
				Pos.x=0
			Pos.x +=64
			var NSlot = InvSlot.instantiate()
			NSlot.global_position = Pos
			add_child(NSlot)
		R = true
		
	if(Input.is_action_just_pressed("OpenInventory")):
		Open = !Open
	for child in get_children():
		child.visible = Open
	
	if(Open == true):
		DrawInvetory()
		
func DrawInvetory():
	return
