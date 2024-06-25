extends Control
var hunters = false
@onready var Buttons = {
	"AttackUpButton": $Panel/AttackUp,
	"AffinityUpButton": $Panel/AffinityUp,
	"Elementpopup": $Panel/ElementUp/Popup,
	"AddHunterButton": $Panel/AddHunter,
	"ManageHunterPanel": $Panel/AddHunter/PopupPanel,
	
	"HunterAttackUpButton": {
		"Hunter1": $"Panel/AddHunter/PopupPanel/ManageHunters/Hunter 1/HunterAttackUp",
		"Hunter2": $"Panel/AddHunter/PopupPanel/ManageHunters/Hunter 2/HunterAttackUp"
	},
	
	"HunterAffinityUpButton": {
		"Hunter1": $"Panel/AddHunter/PopupPanel/ManageHunters/Hunter 1/HunterAffinityUp",
		"Hunter2": $"Panel/AddHunter/PopupPanel/ManageHunters/Hunter 2/HunterAffinityUp"
	},
	
	"WeaponButton": {
		"Hunter1": $"Panel/AddHunter/PopupPanel/ManageHunters/Hunter 1/weapon"
	},
	
	"ElementalButtons": {
	"Fire": {"Price": 200, "Path": $Panel/ElementUp/Popup/VBoxContainer/FireUp},
	"Ice": {"Price": 200,"Path": $Panel/ElementUp/Popup/VBoxContainer/IceUp},
	"Thunder": {"Price": 200,"Path": $Panel/ElementUp/Popup/VBoxContainer/ThunderUp},
	"Water": {"Price": 200,"Path": $Panel/ElementUp/Popup/VBoxContainer/WaterUp},
	"Dragon": {"Price": 200,"Path": $Panel/ElementUp/Popup/VBoxContainer/DragonUp}
}
}
# Called when the node enters the scene tree for the first time.
func _ready():
	Buttons["AttackUpButton"].text = "Increase Attack - %s" % Data.prices["Price Attack"]
	Buttons["AffinityUpButton"].text = "Increase Affinity - %s" % Data.prices["Price Affinity"]
	Buttons["AddHunterButton"].text = "Add Hunter - %d" % Data.prices["Price Hunter"]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#When you purchase an Attack Boost, functions from data.gd get called to subtract the money and add the damage
func _on_attack_up_pressed():
	#Adds 2.5 to your raw damage
	var damage_amount = 2.5
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
	Buttons["Elementpopup"].popup()
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
	

#Sets the price for the next hunter purchased. Does not set the hunter themselves
func _on_add_hunter_pressed():
	if hunters == true:
		Buttons["ManageHunterPanel"].visible = true
	else:
		if Data.zenny >= Data.prices["Price Hunter"]:
			Data.subtract_money(Data.prices["Price Hunter"])
			#Calls a function which sends a signal to hunters.gd
			Data.AddedHunter()
			#Sets the price increase for the next purchase 
			Data.prices["Price Hunter"] = Data.prices["Price Hunter"] * 10
			hunters = true
			Buttons["AddHunterButton"].text = "Manage Hunters"


func _on_hunter_attack_up_pressed(argument):
	if Data.zenny >= Data.prices["Price Hunterdmg"]:
		Data.subtract_money(Data.prices["Price Hunterdmg"])
		Data.add_hunterdamage(argument)
		Data.prices["Price Hunterdmg"] += 600
		Buttons["HunterAttackUpButton"][argument].text = "Increase Attack - %s" % Data.prices["Price Hunterdmg"]
	


func _on_hunter_affinity_up_pressed(argument):
	if Data.zenny >= Data.prices["Price Hunteraff"]:
		if Data.hunters[argument]["HunterAffinity"] == 100:
			Buttons["HunterAffinityUpButton"][argument].text = "Max Affinity"
		else:
			Data.subtract_money(Data.prices["Price Hunteraff"])
			Data.add_hunteraffinity(argument)
			Data.prices["Price Hunteraff"] += 2000
			print(Data.hunters[argument]["HunterAffinity"])
			Buttons["HunterAffinityUpButton"][argument].text = "Increase Affinity - %s" % Data.prices["Price Hunteraff"]
