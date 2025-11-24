extends Node3D

var InvSlot = preload("res://Scenes/InventorySlot.tscn")
var SelSlot = preload("res://Scenes/SelectedItemSlot.tscn")
var IScript
var R = false

var Open = false
var SlotObj = []
var HBSlotObj = []

var SelectedSlot = 0
var SelectedItem = null
var SSObj = null

var ToUpdate = true

func _physics_process(delta: float) -> void:
	#has to ready after the inventory script is loaded so put it a frame after
	if(R == false):
		IScript = get_node("/root/Node3D/Player/InventoryManager")
		var Pos = Vector2(0, 0)
		var Dist = 64
		for i in range(IScript.InvSize):
			if(Pos.x == 8*Dist):
				Pos.y+=Dist
				Pos.x=0
			Pos.x +=Dist
			var NSlot = InvSlot.instantiate()
			NSlot.global_position = Pos
			add_child(NSlot)
			SlotObj.append(NSlot)
		Pos = Vector2(256, 512)
		for i in range(IScript.HotbarSize):
			Pos.x +=Dist
			var NSlot = InvSlot.instantiate()
			NSlot.global_position = Pos
			add_child(NSlot)
			HBSlotObj.append(NSlot)
		R = true
	#make it try to put items back in your invetory beore dropping them when they are dragged out when the inventory is closed
	if(Input.is_action_just_pressed("OpenInventory")):
		Open = !Open
		if(SelectedItem != null):
			for i in range(SelectedItem.Amt):
				IScript.SpawnItem(SelectedItem, get_node("/root/Node3D/Player").global_position+Vector3.FORWARD*2+(Vector3.UP)*(i+1))
			SelectedItem = null
			SSObj.queue_free()
			SSObj = null
		ToUpdate = true
	var l = 0
	for child in get_children():
		l+=1
		child.visible = Open
		if(l==IScript.InvSize):
			break
	DrawInvetory()
	
	if(Open == true):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		var MPos = get_viewport().get_mouse_position()
		var INI = 0
		SelectedSlot = -1
		for i in range(SlotObj.size()):
			if(SlotObj[i].get_node("Slot").get_global_rect().has_point(MPos)):
				INI = 1
				SelectedSlot = i
				SlotObj[SelectedSlot].get_node("Slot").modulate = Color(0.7, 0.7, 0.7)
			else:
				SlotObj[i].get_node("Slot").modulate = Color(1, 1, 1)
		if(INI == 0):
			for i in range(HBSlotObj.size()):
				if(HBSlotObj[i].get_node("Slot").get_global_rect().has_point(MPos)):
					INI = 1
					SelectedSlot = IScript.InvSize + i
					HBSlotObj[SelectedSlot-IScript.InvSize].get_node("Slot").modulate = Color(0.7, 0.7, 0.7)
				else:
					HBSlotObj[i].get_node("Slot").modulate = Color(1, 1, 1)
		if(INI == 0):
			SelectedSlot = -1
		
		if(SelectedItem != null && SelectedItem.Amt == 0):
			SelectedItem = null
			SSObj.queue_free()
			SSObj = null
			ToUpdate = true
		
		#Pickup item from slot if the player doesnt have any selected items
		if(Input.is_action_just_pressed("LeftClick") && SelectedSlot != -1 && IScript.Inv[SelectedSlot].Name != "Empty" && SelectedItem == null):
			print("ITEM PICKED UP")
			SelectedItem = IScript.Inv[SelectedSlot]
			IScript.Inv[SelectedSlot] = ITEMLIST.ITEM_ARRAY[0]
			#Set the selected slot
			SSObj = SelSlot.instantiate()
			add_child(SSObj)
			SelectedSlot = -1
			ToUpdate = true
			return
		#If selected item is outside of the inventory, drop it (INI = 0 means its out of the inventory)
		if(Input.is_action_just_pressed("LeftClick") && INI == 0 && SelectedItem!=null):
			print("ITEM DROPPED")
			for i in range(SelectedItem.Amt):
				IScript.SpawnItem(SelectedItem, get_node("/root/Node3D/Player").global_position+Vector3.FORWARD*2+(Vector3.UP)*(i+1))
			SelectedItem = null
			SSObj.queue_free()
			SSObj = null
		#Do a bunch of things if a selected item is clicked whilst inside the inventory
		if(Input.is_action_just_pressed("LeftClick") && INI == 1 && SelectedItem!=null):
			#Put the selected item in a new slot if the slot that is selected it empty
			if(IScript.Inv[SelectedSlot].Name == "Empty"):
				print("ITEM PUT BACK")
				IScript.Inv[SelectedSlot] = SelectedItem
				SelectedItem = null
				SSObj.queue_free()
				SSObj = null
				ToUpdate = true
				return
			else:
				#Since slot is full check if its the same item in the slot and the stack size wont be reached if the two items are combined
				if(IScript.Inv[SelectedSlot].Name == SelectedItem.Name && IScript.Inv[SelectedSlot].Amt + SelectedItem.Amt <= SelectedItem.StackSize):
					print("ITEM VALID STACKED")
					IScript.Inv[SelectedSlot].Amt += SelectedItem.Amt
					SelectedItem = null
					SSObj.queue_free()
					SSObj = null
					ToUpdate=true
					return
				#the stack size will be reached if the items combine so only put the amount in that you can
				elif(IScript.Inv[SelectedSlot].Name == SelectedItem.Name && IScript.Inv[SelectedSlot].Amt < IScript.Inv[SelectedSlot].StackSize):
					print("ITEM PARTLY STACKED")
					SelectedItem.Amt = abs(IScript.Inv[SelectedSlot].StackSize - IScript.Inv[SelectedSlot].Amt - SelectedItem.Amt)
					IScript.Inv[SelectedSlot].Amt = SelectedItem.StackSize
					ToUpdate = true
					return
				#Switches items in a slot to the ones you are holding in your hand
				if(IScript.Inv[SelectedSlot].Name != "Empty" && IScript.Inv[SelectedSlot].Name != SelectedItem.Name):
					var Temp = IScript.Inv[SelectedSlot]
					IScript.Inv[SelectedSlot] = SelectedItem
					SelectedItem = Temp
					ToUpdate = true
					return
				
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func DrawInvetory():
	if(ToUpdate == true):
		if(Open == true):
			for i in range(IScript.InvSize):
				SlotObj[i].get_node("Slot/Tex").texture = null
				SlotObj[i].get_node("Slot/Amount").text = str("0")
				SlotObj[i].get_node("Slot").modulate = Color(1, 1, 1)
			for i in range(IScript.InvSize):
				if(IScript.Inv[i].Name != "Empty"):
					SlotObj[i].get_node("Slot/Tex").texture = load(IScript.Inv[i].TextPath)
					SlotObj[i].get_node("Slot/Tex").scale = Vector2(48, 48)/SlotObj[i].get_node("Slot/Tex").texture.get_size()
					SlotObj[i].get_node("Slot/Amount").text = str(IScript.Inv[i].Amt)
		for i in range(IScript.HotbarSize):
			HBSlotObj[i].get_node("Slot/Tex").texture = null
			HBSlotObj[i].get_node("Slot/Amount").text = str("0")
			HBSlotObj[i].get_node("Slot").modulate = Color(1, 1, 1)
		for i in range(IScript.HotbarSize):
			if(IScript.Inv[IScript.InvSize + i].Name != "Empty"):
				HBSlotObj[i].get_node("Slot/Tex").texture = load(IScript.Inv[IScript.InvSize + i].TextPath)
				HBSlotObj[i].get_node("Slot/Tex").scale = Vector2(48, 48)/HBSlotObj[i].get_node("Slot/Tex").texture.get_size()
				HBSlotObj[i].get_node("Slot/Amount").text = str(IScript.Inv[IScript.InvSize + i].Amt)
	ToUpdate = false
	if(SelectedItem != null):
		SSObj.get_node("Tex").texture = load(SelectedItem.TextPath)
		SSObj.get_node("Tex").scale = Vector2(48, 48)/SSObj.get_node("Tex").texture.get_size()
		SSObj.get_node("Amount").text = str(SelectedItem.Amt)
		SSObj.global_position = get_viewport().get_mouse_position()
