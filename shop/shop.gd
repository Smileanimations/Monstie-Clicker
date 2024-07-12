extends Control
var hunters = false
var weapons = preload("res://shop/weapons/weapon.tscn")
var weaponpanel = preload("res://shop/hunterpanel/hunterpanel.tscn")
var itemshop = preload("res://shop/itemshop/itemshop.tscn")
var PurchaseHunterButton
var iteminstance
@onready var Buttons = {
	"AttackUpButton": $Panel/AttackUp,
	"AffinityUpButton": $Panel/AffinityUp,
	"AddHunterButton": $Panel/AddHunter,
	"ItemShopButton": $Panel/ItemShop,
	
	
	"ElementalButtons": {
	"Fire": {"Price": 200, "Path": $Panel/ElementUp/Popup/VBoxContainer/FireUp},
	"Ice": {"Price": 200,"Path": $Panel/ElementUp/Popup/VBoxContainer/IceUp},
	"Thunder": {"Price": 200,"Path": $Panel/ElementUp/Popup/VBoxContainer/ThunderUp},
	"Water": {"Price": 200,"Path": $Panel/ElementUp/Popup/VBoxContainer/WaterUp},
	"Dragon": {"Price": 200,"Path": $Panel/ElementUp/Popup/VBoxContainer/DragonUp}
}
}

@onready var Containers = {
	"Elementpopup": $Panel/ElementUp/Popup,
	"ManageHunterPanel": $Panel/AddHunter/PopupPanel,
	"ManageHunterTab": $Panel/AddHunter/PopupPanel/ManageHunters,
	"ItemShopPanel": $Panel/ItemShop/ItemPopupPanel,
	"ItemScrollContainer": $Panel/ItemShop/ItemPopupPanel/ItemScrollContainer,
	"ItemShopTab": $Panel/ItemShop/ItemPopupPanel/ItemScrollContainer/HBoxContainer,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	Buttons["AttackUpButton"].text = "Increase Attack - %s" % Data.prices["Price Attack"]
	Buttons["AffinityUpButton"].text = "Increase Affinity - %s" % Data.prices["Price Affinity"]
	Data.HunterUnlocked.connect(huntersunlocked)
	for i in range (1, 5):
		var instance = weaponpanel.instantiate()
		instance.name = "Hunter %s" % i
		Containers["ManageHunterTab"].add_child(instance)
		var AttackUpButton = instance.get_node("HunterAttackUp")
		var AffinityUpButton = instance.get_node("HunterAffinityUp")
		var WeaponButton = instance.get_node("Weapon")
		PurchaseHunterButton = instance.get_node("PurchaseHunter")
		AttackUpButton.pressed.connect(instance._on_hunter_attack_up_pressed.bind("Hunter%s" % i))
		AffinityUpButton.pressed.connect(instance._on_hunter_affinity_up_pressed.bind("Hunter%s" % i))
		WeaponButton.pressed.connect(instance._on_weapon_pressed.bind("Hunter%s" % i))
		PurchaseHunterButton.pressed.connect(instance._on_purchase_hunter_pressed.bind("Hunter%s" % i))
	for i in Data.iteminventory:
		iteminstance = itemshop.instantiate()
		iteminstance.texture_normal = load(Data.iteminventory[i]["Path"])
		iteminstance.item = i
		Containers["ItemShopTab"].add_child(iteminstance)


#When you purchase an Attack Boost, functions from data.gd get called to subtract the money and add the damage
func _on_attack_up_pressed():
	#Adds 2.5 to your raw damage
	var damage_amount = 3
	if Data.zenny >= Data.prices["Price Attack"]:
		Data.subtract_money(Data.prices["Price Attack"])
		Data.add_damage(damage_amount)
		#Sets the price increase for the next purchase 
		Data.prices["Price Attack"] += 300
		Buttons["AttackUpButton"].text = "Increase Attack - %s" % Data.prices["Price Attack"]


#When you purchase an Affinity Boost, functions from data.gd get called to subtract the money and add the affinity
func _on_affinity_up_pressed():
	#Adds 1% affinity
	var affinity_amount = 1
	if Data.zenny >= Data.prices["Price Affinity"]:
		if Data.damage["Affinity"]["Amount"] == 100:
			Buttons["AffinityUpButton"].text ="Max Affinity"
		else:
			Data.subtract_money(Data.prices["Price Affinity"])
			Data.add_affinity(affinity_amount)
			#Sets the price increase for the next purchase 
			Data.prices["Price Affinity"] += Data.prices["Price Affinity"] * 2
			Buttons["AffinityUpButton"].text = "Increase Affinity - %s" % Data.prices["Price Affinity"]


#Pops up a window containing all elemental buttons
func _on_element_up_pressed():
	Containers["Elementpopup"].popup()
#Adds the corospondent element which you purchased to the damage array
func _on_element_button_pressed(element):
	#Adds 2 elemental damage 
	var element_amount = 2
	print("%s" % Buttons["ElementalButtons"][element]["Price"])
	if Data.zenny >= Buttons["ElementalButtons"][element]["Price"]:
		Data.subtract_money(Buttons["ElementalButtons"][element]["Price"])
		Data.add_element(element, element_amount)
		Data.damage[element]["Damage_amount"] += 2
		#Sets the price increase for the next purchase 
		Buttons["ElementalButtons"][element]["Price"] = int(Buttons["ElementalButtons"][element]["Price"] * 1.5)
		Buttons["ElementalButtons"][element]["Path"].text = "Increase %s Dmg - %s" % [element, Buttons["ElementalButtons"][element]["Price"]]
	

func huntersunlocked():
	Buttons["AddHunterButton"].visible = true

#Sets the price for the next hunter purchased. Does not set the hunter themselves
func _on_add_hunter_pressed():
	Containers["ManageHunterPanel"].visible = true

func _on_item_shop_pressed():
	Containers["ItemShopPanel"].visible = true
