extends Panel
var hunter = 1
signal weapon_change(weapon, local_hunter)
var local_hunter
var weapons = preload("res://shop/weapons/weapon.tscn")
@onready var HunterAttackUpButton = $HunterAttackUp
@onready var HunterAffinityUpButton = $HunterAffinityUp
@onready var WeaponButton = $Weapon
@onready var WeaponPanel = $WeaponPanel
@onready var WeaponContainer = $WeaponPanel/Container

# Called when the node enters the scene tree for the first time.
func _ready():
	for value in Data.weapons:
		var instance = weapons.instantiate()
		instance.LoadWeapons(Data.weapons[value])
		instance.weapon_changed.connect(Weaponupdated)
		WeaponContainer.add_child(instance)
		add_to_group("WeaponGroup") 



func _on_hunter_attack_up_pressed(hunter):
	if Data.zenny >= Data.prices["Price Hunterdmg"]:
		Data.subtract_money(Data.prices["Price Hunterdmg"])
		Data.add_hunterdamage(hunter)
		Data.prices["Price Hunterdmg"] += 600
		HunterAttackUpButton.text = "Increase Attack - %s" % Data.prices["Price Hunterdmg"]
	


func _on_hunter_affinity_up_pressed(hunter):
	if Data.zenny >= Data.prices["Price Hunteraff"]:
		if Data.hunters[hunter]["HunterAffinity"] == 100:
			HunterAffinityUpButton[hunter].text = "Max Affinity"
		else:
			Data.subtract_money(Data.prices["Price Hunteraff"])
			Data.add_hunteraffinity(hunter)
			Data.prices["Price Hunteraff"] += 2000
			print(Data.hunters[hunter]["HunterAffinity"])
			HunterAffinityUpButton.text = "Increase Affinity - %s" % Data.prices["Price Hunteraff"]

func _on_weapon_pressed(hunter):
	local_hunter = hunter
	WeaponPanel.visible = true

func Weaponupdated(weapon):
	Data.hunters[local_hunter]["Weapon"] = weapon
	WeaponButton.icon = load(weapon["Path"])
	weapon_change.emit(weapon, local_hunter)

func _on_purchase_hunter_pressed():
	pass # Replace with function body.
