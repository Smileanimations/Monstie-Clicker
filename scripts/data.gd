extends Node
var zenny : int = 100000000
var difficulty_scale =  1
var hunter_rank : int = 0
var damage = {
	"Raw": {"Damage_amount": 10},
	"Affinity": {"Amount": 0},
	"Fire": {"Damage_amount": 0},
	"Ice": {"Damage_amount": 0},
	"Water": {"Damage_amount": 0},
	"Thunder": {"Damage_amount": 0},
	"Dragon": {"Damage_amount": 0}
}
var weapons = {
	"Greatsword": {"Damage_amount": 100, "Affinity": 0, "Cooldown": 5, "Path": "res://images/UI Icons/Weapon Icons/Great_Sword.png"},
	"Longsword": {"Damage_amount": 15, "Affinity": 0, "Cooldown": 2, "Path": "res://images/UI Icons/Weapon Icons/Long_Sword.png"},
	"Sword And Shield": {"Damage_amount": 10, "Affinity": 0, "Cooldown": 0.5, "Path": "res://images/UI Icons/Weapon Icons/Sword_And_Shield.png"},
	"Dual Blades": {"Damage_amount": 5, "Affinity": 0, "Cooldown": 0.2, "Path": "res://images/UI Icons/Weapon Icons/Dual_Blades.png"}
}

@onready var hunters = {
	"Hunter1": {"HunterDamage": 0, "HunterAffinity": 0, "Weapon": Data.weapons["Greatsword"]},
	"Hunter2": {"HunterDamage": 0, "HunterAffinity": 0, "Weapon": Data.weapons["Sword And Shield"]},
	"Hunter3": {"HunterDamage": 0, "HunterAffinity": 0, "Weapon": Data.weapons["Dual Blades"]},
	"Hunter4": {"HunterDamage": 0, "HunterAffinity": 0, "Weapon": Data.weapons["Longsword"]}
}

signal zenny_updated
signal update_stat_display
signal PurchasedHunter
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#Function that adds zenny and updates the display
func add_money(amount):
	zenny += amount
	zenny_updated.emit()

#Function that subtracts zenny and updates the display
func subtract_money(amount):
	zenny -= amount
	zenny_updated.emit()

#Adds the given amount of damage and updates in on the display
func add_damage(amount):
	damage["Raw"]["Damage_amount"] += amount
	update_stat_display.emit()
#Adds the given amount of affinity and updates in on the display
func add_affinity(amount):
	damage["Affinity"]["Amount"] += amount
	update_stat_display.emit()
#Adds the given amount of elemental damage
func add_element(element, amount):
	damage[element]["Damage_amount"] += amount
#Adds the given amount of damage to the hunter
func add_hunterdamage(hunter):
	Data.hunters[hunter]["HunterDamage"] += Data.hunters["Hunter1"]["Weapon"]["Damage_amount"] * 0.15
#Adds the given amount of difficulty and updates in on the display
func add_diff_scale(amount):
	difficulty_scale = difficulty_scale + amount
	update_stat_display.emit()
#Sends the signal to hunter.gd which adds a hunter
func AddedHunter():
	PurchasedHunter.emit()
