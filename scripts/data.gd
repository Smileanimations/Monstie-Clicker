extends Node
signal MonstersUnlocked(batch)
signal HunterUnlocked
var batch = 1
var zenny : int = 150000000
var points : int = 0
var difficulty_scale : int =  0
var hunter_rank : int = 4
var hunter_rankxp : int = 30
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
	"Longsword": {"Damage_amount": 30, "Affinity": 0, "Cooldown": 2, "Path": "res://images/UI Icons/Weapon Icons/Long_Sword.png"},
	"Sword And Shield": {"Damage_amount": 10, "Affinity": 0, "Cooldown": 0.5, "Path": "res://images/UI Icons/Weapon Icons/Sword_And_Shield.png"},
	"Dual Blades": {"Damage_amount": 2, "Affinity": 0, "Cooldown": 0.2, "Path": "res://images/UI Icons/Weapon Icons/Dual_Blades.png"}
}

@onready var hunters = {
	"Hunter1": {"Health": 100, "Stamina": 100, "HunterDamage": int(0), "HunterAffinity": int(0), "Weapon": Data.weapons["Greatsword"], "Price Hunterdmg": int(300), "Price Hunteraff": int(1000), "Damage": int(0)},
	"Hunter2": {"Health": 100, "Stamina": 100, "HunterDamage": int(0), "HunterAffinity": int(0), "Weapon": Data.weapons["Sword And Shield"], "Price Hunterdmg": int(300), "Price Hunteraff": int(1000), "Damage": int(0)},
	"Hunter3": {"Health": 100, "Stamina": 100, "HunterDamage": int(0), "HunterAffinity": int(0), "Weapon": Data.weapons["Dual Blades"], "Price Hunterdmg": int(300), "Price Hunteraff": int(1000), "Damage": int(0)},
	"Hunter4": {"Health": 100, "Stamina": 100, "HunterDamage": int(0), "HunterAffinity": int(0), "Weapon": Data.weapons["Longsword"], "Price Hunterdmg": int(300), "Price Hunteraff": int(1000), "Damage": int(0)}
}

var iteminventory = {
	"Whetstone": {"Amount": 0, "Price": 750, "Star": false ,"Path": "res://images/UI Icons/Item Icons/Whetstone.png"},
	"Potion": {"Amount": 10, "Price": 200, "Star": false, "Path": "res://images/UI Icons/Item Icons/Potion.png"},
	"Mega Potion": {"Amount": 0, "Price": 500, "Star": true, "Path": "res://images/UI Icons/Item Icons/Potion.png"},
	"Armorskin Potion": {"Amount": 0, "Price": 1250, "Star": false ,"Path": "res://images/UI Icons/Item Icons/Armorskin Potion.png"},
	"Mega Armorskin Potion": {"Amount": 0, "Price": 2250, "Star": true ,"Path": "res://images/UI Icons/Item Icons/Armorskin Potion.png"},
	"Hardshell Powder": {"Amount": 0, "Price": 2500, "Star": false ,"Path": "res://images/UI Icons/Item Icons/Hardshell Powder.png"},
	"Demondrug": {"Amount": 0, "Price": 1200, "Star": false ,"Path": "res://images/UI Icons/Item Icons/Demondrug.png"},
	"Mega Demondrug": {"Amount": 0, "Price": 3000, "Star": true, "Path": "res://images/UI Icons/Item Icons/Demondrug.png"},
	"Demonpowder": {"Amount": 0, "Price": 3250, "Star": false, "Path": "res://images/UI Icons/Item Icons/Demon Powder.png"},
	"Barrel Bomb": {"Amount": 0, "Price": 1500, "Star": false, "Path": "res://images/UI Icons/Item Icons/Barrel Bomb.png"},
	"Mega Barrel Bomb": {"Amount": 0, "Price": 3000, "Star": true, "Path": "res://images/UI Icons/Item Icons/Barrel Bomb.png"},
	"Shock Trap": {"Amount": 0, "Price": 1700, "Star": false, "Path": "res://images/UI Icons/Item Icons/Shock Trao.png"},
	"Pitfall Trap": {"Amount": 0, "Price": 2000, "Star": false, "Path": "res://images/UI Icons/Item Icons/Pitfall Trap.png"},
}

var prices = {
	"Price Attack" = int(100),
	"Price Affinity" = int(500),
	"Price Hunter" = int(2000),
}

signal zenny_updated
signal update_stat_display
signal PurchasedHunter

func _ready():
	pass

#Function that adds zenny and updates the display
func add_money(amount):
	zenny += amount
	points += amount / 5
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
	Data.hunters[hunter]["HunterDamage"] += Data.hunters[hunter]["Weapon"]["Damage_amount"] * 0.15

#Adds  the given amount of affinity to the hunter
func add_hunteraffinity(hunter):
	Data.hunters[hunter]["HunterAffinity"] += 1

#Adds the given amount of difficulty and updates in on the display
func add_diff_scale(amount):
	difficulty_scale = difficulty_scale + amount
	update_stat_display.emit()

#Sends the signal to hunter.gd which adds a hunter
func AddHunter(hunter_add):
	PurchasedHunter.emit(hunter_add)

func Hunterrank(HRpoints):
	hunter_rankxp -= HRpoints
	if hunter_rankxp <= 0:
		hunter_rank += 1
		hunter_rankxp = 20 * (difficulty_scale * 0.2)
		update_stat_display.emit()
		if hunter_rank % 10 == 0:
			Audiohandler.queue_sound("TenRanksUp")
		else:
			Audiohandler.queue_sound("HunterRankUp")
		match hunter_rank:
			5:
				Audiohandler.queue_sound("NewUnlocked")
				HunterUnlocked.emit()
			10:
				Audiohandler.queue_sound("NewUnlocked")
				MonstersUnlocked.emit(batch)
				batch += 1
