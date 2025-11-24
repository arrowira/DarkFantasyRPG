extends Node3D

var InvSize = 32
var Inv = []

func _ready() -> void:
	Inv.resize(InvSize)
	for i in range(InvSize):
		Inv[i] = Item.new()
	Inv[0] = ITEMLIST.ADDITEM(1, 6)
	Inv[1] = ITEMLIST.ADDITEM(1, 5)
	Inv[2] = ITEMLIST.ADDITEM(2, 10)
	Inv[3] = ITEMLIST.ADDITEM(2, 18)
	
func PickupItem(NItem):
	for i in range (Inv.size()):
		if(Inv[i].name == NItem.name && Inv[i].Amt + NItem.Amt <= Inv[i].StackSize):
			Inv[i].Amt+=NItem.Amt
		elif(Inv[i].name == NItem.name && Inv[i].Amt < Inv[i].StackSize):
			NItem.Amt-=(Inv[i].StackSize - Inv.Amt)
			Inv[i].Amt = Inv[i].StackSize
		if(Inv[i].name == "Empty"):
			Inv[i] = NItem
			return
	if(NItem.Amt == 0):
		return
	print("Inventory Full, " + NItem.Amt + " Items Left")
	SpawnItem(NItem, global_position)
	
func RemoveItem(Slot):
	Inv[Slot] = Item.new()

func DropItem(Slot):
	SpawnItem(Inv[Slot], global_position)
	RemoveItem(Slot)

func SpawnItem(NItem, Pos):
	var M = load(NItem.ScenePath)
	var NI = M.instantiate()
	NI.position = Pos
	get_node("/root/Node3D").add_child(NI)
	return
