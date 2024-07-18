extends Panel
signal weapon_changed(weapon, local_hunter)
var nodegroup
var local_hunter
var weapons = preload("res://shop/weapons/weapon.tscn")
@onready var HunterAttackUpButton = $HunterAttackUp
@onready var HunterAffinityUpButton = $HunterAffinityUp
@onready var WeaponButton = $Weapon
@onready var PurchaseHunterButton= $PurchaseHunter
@onready var WeaponPanel = $WeaponPanel
@onready var WeaponContainer = $WeaponPanel/Container

# Called when the node enters the scene tree for the first time.
func _ready():
	Data.PurchasedHunter.connect(update_huntercost)
	HunterAttackUpButton.visible = false
	HunterAffinityUpButton.visible = false
	WeaponButton.visible = false
	PurchaseHunterButton.text = "Purchase Hunter - %sz" % Data.prices["Price Hunter"]
	#Loads all the weapons when you open the weapon tab
	for value in Data.weapons:
		var instance = weapons.instantiate()
		instance.LoadWeapons(Data.weapons[value])
		instance.weapon_change.connect(Weaponupdated)
		WeaponContainer.add_child(instance)
	#Adds the all the hunter nodes to a group
	add_to_group("WeaponGroup") 
	nodegroup = get_tree().get_nodes_in_group("WeaponGroup")

func update_huntercost(_ignore):
	PurchaseHunterButton.text = "Purchase Hunter - %sz" % Data.prices["Price Hunter"]

#Increases attack damage of the hunter when purchased
func _on_hunter_attack_up_pressed(hunter):
	if Data.zenny >= Data.hunters[hunter]["Price Hunterdmg"]:
		Data.subtract_money(Data.hunters[hunter]["Price Hunterdmg"])
		Data.add_hunterdamage(hunter)
		Data.hunters[hunter]["Price Hunterdmg"] += 600
		HunterAttackUpButton.text = "Increase Attack - %sz" % Data.hunters[hunter]["Price Hunterdmg"]
	

#Increases affinity of the hunter when purchased
func _on_hunter_affinity_up_pressed(hunter):
	if Data.zenny >= Data.hunters[hunter]["Price Hunteraff"]:
		if Data.hunters[hunter]["HunterAffinity"] == 100:
			HunterAffinityUpButton[hunter].text = "Max Affinity"
		else:
			Data.subtract_money(Data.hunters[hunter]["Price Hunteraff"])
			Data.add_hunteraffinity(hunter)
			Data.hunters[hunter]["Price Hunteraff"] += 2000
			print(Data.hunters[hunter]["HunterAffinity"])
			HunterAffinityUpButton.text = "Increase Affinity - %sz" % Data.hunters[hunter]["Price Hunteraff"]

#Opens a tab showing all available weapons
func _on_weapon_pressed(hunter):
	local_hunter = hunter
	WeaponPanel.visible = true

#Updates the weapon icon to the weapon currently equiped by the hunter
func Weaponupdated(weapon):
	WeaponButton.icon = load(weapon["Path"])
	weapon_changed.emit(weapon, local_hunter)

#When pressed purchases the selected hunter and hides the purchase button whilst showing all stat increase buttons
func _on_purchase_hunter_pressed(hunter):
	if Data.zenny >= Data.prices["Price Hunter"]: 
		Data.subtract_money(Data.prices["Price Hunter"])
		Data.prices["Price Hunter"] *= 20
		PurchaseHunterButton.visible = false
		HunterAttackUpButton.visible = true
		HunterAffinityUpButton.visible = true
		WeaponButton.visible = true
		WeaponButton.icon = load(Data.hunters[hunter]["Weapon"]["Path"])
		Audiohandler.play_audio("PurchasedHunter")
		Data.AddHunter(hunter)

