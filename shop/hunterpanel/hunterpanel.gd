extends Panel
signal weapon_changed(weapon, local_hunter)
signal hunter_item_hover
signal hunter_item_exit

var armorskin = false
var mega_armorskin = false
var hardshell = false
var demondrug = false
var mega_demondrug = false
var nodegroup
var local_hunter
var iteminstance
var weapons = preload("res://shop/weapons/weapon.tscn")
var items = preload("res://shop/itemshop/itemshop.tscn")

#Dictionary containing all the panels and containers
@onready var Containers = {
	"WeaponPanel" = $WeaponPanel,
	"WeaponContainer" = $WeaponPanel/Container,
	"ItemPanel" = $ItemPanel,
	"ItemContainer" = $ItemPanel/Container
}

#Dictionary Containing all the buttons
@onready var Buttons = {
	"HunterAttackUpButton" = $HunterAttackUp,
	"HunterAffinityUpButton" = $HunterAffinityUp,
	"WeaponButton" = $Weapon,
	"InventoryButton" = $Inventory,
	"PurchaseHunter" = $PurchaseHunter
}

@onready var Timers = {
	"Hardshell Timer" = $HardshellTimer,
	"Demondrug Timer" = $DrugsTimer
}
# Called when the node enters the scene tree for the first time.
func _ready():
	#Binds the all 4 hunters to the buttons that increase stats and other changes 
	Buttons["HunterAttackUpButton"].pressed.connect(_on_hunter_attack_up_pressed.bind(name))
	Buttons["HunterAffinityUpButton"].pressed.connect(_on_hunter_affinity_up_pressed.bind(name))
	Buttons["WeaponButton"].pressed.connect(_on_weapon_pressed.bind(name))
	Buttons["PurchaseHunter"].pressed.connect(_on_purchase_hunter_pressed.bind(name))
	Data.PurchasedHunter.connect(update_huntercost)
	Buttons["HunterAttackUpButton"].visible = false
	Buttons["HunterAffinityUpButton"].visible = false
	Buttons["WeaponButton"].visible = false
	Buttons["InventoryButton"].visible = false
	Buttons["PurchaseHunter"].text = "Purchase Hunter - %sz" % Data.prices["Price Hunter"]
	#Loads all the weapons when you open the weapon tab
	for value in Data.weapons:
		var instance = weapons.instantiate()
		instance.LoadWeapons(Data.weapons[value])
		instance.weapon_change.connect(Weaponupdated)
		Containers["WeaponContainer"].add_child(instance)
	#Adds the all the hunter nodes to a group
	add_to_group("WeaponGroup") 
	nodegroup = get_tree().get_nodes_in_group("WeaponGroup")
	for i in Data.iteminventory:
		iteminstance = items.instantiate()
		iteminstance.texture_normal = load(Data.iteminventory[i]["Path"])
		iteminstance.item = i
		iteminstance.mouse_entered.connect(itemhover.bind(i))
		iteminstance.mouse_exited.connect(itemexit)
		iteminstance.pressed.connect(_on_item_pressed.bind(i))
		Containers["ItemContainer"].add_child(iteminstance)
		iteminstance.visible = false
	var hunters = get_node("/root/main/hunters")
	var monsters = get_node("/root/main/monster")
	hunters.resetbuffs.connect(resetbuffs)
	monsters.resetbuffs.connect(resetbuffs)

func update_huntercost(_ignore):
	Buttons["PurchaseHunter"].text = "Purchase Hunter - %sz" % Data.prices["Price Hunter"]

#Increases attack damage of the hunter when purchased
func _on_hunter_attack_up_pressed(hunter):
	if Data.zenny >= Data.hunters[hunter]["Price Hunterdmg"]:
		Data.subtract_money(Data.hunters[hunter]["Price Hunterdmg"])
		Data.add_hunterdamage(hunter)
		Data.hunters[hunter]["Price Hunterdmg"] += 600
		Buttons["HunterAttackUpButton"].text = "Increase Attack - %sz" % Data.hunters[hunter]["Price Hunterdmg"]
	

#Increases affinity of the hunter when purchased
func _on_hunter_affinity_up_pressed(hunter):
	if Data.zenny >= Data.hunters[hunter]["Price Hunteraff"]:
		if Data.hunters[hunter]["HunterAffinity"] == 100:
			Buttons["HunterAffinityUpButton"][hunter].text = "Max Affinity"
		else:
			Data.subtract_money(Data.hunters[hunter]["Price Hunteraff"])
			Data.add_hunteraffinity(hunter)
			Data.hunters[hunter]["Price Hunteraff"] += 2000
			print(Data.hunters[hunter]["HunterAffinity"])
			Buttons["HunterAffinityUpButton"].text = "Increase Affinity - %sz" % Data.hunters[hunter]["Price Hunteraff"]

#Opens a tab showing all available weapons
func _on_weapon_pressed(hunter):
	local_hunter = hunter
	Containers["WeaponPanel"].visible = true

#Updates the weapon icon to the weapon currently equiped by the hunter
func Weaponupdated(weapon):
	Buttons["WeaponButton"].icon = load(weapon["Path"])
	weapon_changed.emit(weapon, local_hunter)

#When pressed purchases the selected hunter and hides the purchase button whilst showing all stat increase buttons
func _on_purchase_hunter_pressed(hunter):
	if Data.zenny >= Data.prices["Price Hunter"]: 
		Data.subtract_money(Data.prices["Price Hunter"])
		Data.prices["Price Hunter"] *= 20
		Buttons["PurchaseHunter"].visible = false
		Buttons["HunterAttackUpButton"].visible = true
		Buttons["HunterAffinityUpButton"].visible = true
		Buttons["WeaponButton"].visible = true
		Buttons["InventoryButton"].visible = true
		Buttons["WeaponButton"].icon = load(Data.hunters[hunter]["Weapon"]["Path"])
		Audiohandler.play_audio("PurchasedHunter")
		Data.AddHunter(hunter)

func _on_inventory_pressed():
	var itemnodes = Containers["ItemContainer"].get_children()
	for i in itemnodes:
		if Data.iteminventory[i.item]["Amount"] > 0:
			i.visible = true
		else:
			i.visible = false
	Containers["ItemPanel"].visible = true

func itemhover(item):
	hunter_item_hover.emit(item)

func itemexit():
	hunter_item_exit.emit()

func _on_item_pressed(item):
	if Data.hunters[name]["Health"] <= 0:
		Audiohandler.play_audio("Denied")
	elif Data.iteminventory[item]["Amount"] <= 0:
			Audiohandler.play_audio("Denied")
	else:
		match item:
			"Potion":
				Data.hunters[name]["Health"] += 35
				Data.iteminventory[item]["Amount"] -= 1
				itemhover(item)
				Audiohandler.play_audio("ItemUse")
				print("%s" % Data.hunters[name]["Health"])
			"Mega Potion":
				Data.hunters[name]["Health"] += 70
				Data.iteminventory[item]["Amount"] -= 1
				itemhover(item)
				Audiohandler.play_audio("ItemUse")
			"Lifepowder":
				for i in range (1, 5):
					if Data.hunters["Hunter%s" % i]["Health"] > 0:
						Data.hunters["Hunter%s" % i]["Health"] += 35
				Data.iteminventory[item]["Amount"] -= 1
				itemhover(item)
				Audiohandler.play_audio("ItemUse")
			"Dust of Life":
				for i in range (1, 5):
					if Data.hunters["Hunter%s" % i]["Health"] > 0:
						Data.hunters["Hunter%s" % i]["Health"] += 70
				Data.iteminventory[item]["Amount"] -= 1
				itemhover(item)
				Audiohandler.play_audio("ItemUse")
			"Armorskin Potion":
				if armorskin:
					Audiohandler.play_audio("Denied")
				else:
					Data.hunters[name]["Defense"] += 15
					Data.iteminventory[item]["Amount"] -= 1
					itemhover(item)
					Audiohandler.play_audio("ItemUse")
					armorskin = true
			"Mega Armorskin Potion":
				if mega_armorskin:
					Audiohandler.play_audio("Denied")
				else:
					if armorskin:
						Data.hunters[name]["Defense"] -= 15
					Data.hunters[name]["Defense"] += 25
					Data.iteminventory[item]["Amount"] -= 1
					itemhover(item)
					Audiohandler.play_audio("ItemUse")
					armorskin = true
					mega_armorskin = true
			"Hardshell Powder":
				if hardshell:
					Timers["Hardshell Timer"].start()
				else:
					for i in range (1, 5):
						Data.hunters["Hunter%s" % i]["Defense"] += 20
					Data.iteminventory[item]["Amount"] -= 1
					itemhover(item)
					Audiohandler.play_audio("ItemUse")
					hardshell = true
					Timers["Hardshell Timer"].start()

func resetbuffs():
	for i in range (1, 5):
		if mega_armorskin:
			Data.hunters["Hunter%s" % i]["Defense"] -= 25
			armorskin = false
			mega_armorskin = false
		elif armorskin:
			Data.hunters["Hunter%s" % i]["Defense"] -= 15
			armorskin = false
		if hardshell:
			Data.hunters["Hunter%s" % i]["Defense"] -= 20
			hardshell = false

func _on_hardshell_timer_timeout():
	for i in range (1, 5):
		if hardshell:
			Data.hunters["Hunter%s" % i]["Defense"] -= 20
			hardshell = false
