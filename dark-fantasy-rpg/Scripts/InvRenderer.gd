extends Node3D

var InvSlot = preload("res://Scenes/InventorySlot.tscn")
var IScript
var R = false

var OInv
var Open = false
var SlotObj = []

func _physics_process(delta: float) -> void:
	#has to ready after the inventory script is loaded so put it a frame after
	if(R == false):
		IScript = get_node("/root/Node3D/Player/InventoryManager")
		OInv = IScript.Inv
		var Pos = Vector2(0, 0)
		var Dist = 64
		for i in range(OInv.size()):
			if(Pos.x == 8*Dist):
				Pos.y+=Dist
				Pos.x=0
			Pos.x +=Dist
			var NSlot = InvSlot.instantiate()
			NSlot.global_position = Pos
			add_child(NSlot)
			SlotObj.append(NSlot)
		R = true
		
	if(Input.is_action_just_pressed("OpenInventory")):
		Open = !Open
	for child in get_children():
		child.visible = Open
	
	if(Open == true):
		DrawInvetory()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
func DrawInvetory():
	for i in range(OInv.size()):
		if(OInv[i].Name != "Empty"):
			SlotObj[i].get_node("Slot/Tex").texture = OInv[i].Tex
			SlotObj[i].get_node("Slot/Tex").scale = Vector2(48, 48)/SlotObj[i].get_node("Slot/Tex").texture.get_size()
			SlotObj[i].get_node("Slot/Amount").text = str(OInv[i].Amt)
			
	return
