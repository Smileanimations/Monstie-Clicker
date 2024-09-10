extends Control
var value
var rand_monster
var health : int = 100
var difficulty : int = 1
var hunter
var hunter_node
signal damage_hunter
signal change_locale
@onready var Monster_Button = $Monster
@onready var Healthbar = $Healthbar
@onready var DamageTimer = $Timer

#A Dictionary containing all current monsters
var monsters = {
	"Kulu-Ya-Ku": {"health":100, "damage": 5, "damage_cooldown": 4, "zenny": 90, "HRpoints": 5,"path": "res://images/Kulu.png", "Locale": "Ancient Forest"},
	"Tzitzi-Ya-Ku": {"health": 125, "damage": 6, "damage_cooldown": 4, "zenny":100, "HRpoints": 5,"path": "res://images/Tzitzi.png", "Locale": "Coral Highlands"},
	"Great Jagras": {"health": 150, "damage": 7, "damage_cooldown": 5, "zenny": 100, "HRpoints": 10,"path": "res://images/Jagras.png", "Locale": "Ancient Forest"},
	"Great Girros": {"health": 150, "damage": 8, "damage_cooldown": 5, "zenny": 100, "HRpoints": 10,"path": "res://images/Girros.png", "Locale": "Rotten Vale"},
	"Jyuratodus": {"health":200, "damage": 10, "damage_cooldown": 5, "zenny": 110, "HRpoints": 15,"path": "res://images/Jyuratodus.png", "Locale": "Wildspire Waste"},
	"Dodogama": {"health": 225, "damage": 11, "damage_cooldown": 6, "zenny": 120, "HRpoints": 15,"path": "res://images/Dodogama.png", "Locale": "Elders Recess"},
	"Pukei-Pukei": {"health":250, "damage": 12, "damage_cooldown": 6, "zenny": 130, "HRpoints": 20,"path": "res://images/Pukei.png", "Locale": "Ancient Forest"},
	"Tobi-Kadachi": {"health":275, "damage": 14, "damage_cooldown": 4, "zenny": 150, "HRpoints": 20,"path": "res://images/Tobi.png", "Locale": "Ancient Forest"},
	"Barroth": {"health":300, "damage": 15, "damage_cooldown": 6, "zenny": 140, "HRpoints": 25,"path": "res://images/Barroth.png", "Locale": "Wildspire Waste"},
}

var batches = [
	{
		"Paolumu": {"health": 325, "damage": 20, "damage_cooldown": 6, "zenny": 250, "HRpoints": 50,"path": "res://images/Paolumu.png", "Locale": "Coral Highlands"},
		"Rathian": {"health": 350, "damage": 22, "damage_cooldown": 6, "zenny": 275, "HRpoints": 55,"path": "res://images/Rathian.png", "Locale": "Wildspire Waste"},
		"Radobaan": {"health": 375, "damage": 22, "damage_cooldown": 7, "zenny": 300, "HRpoints": 50,"path": "res://images/Radobaan.png", "Locale": "Rotten Vale"},
		"Anjanath": {"health": 400, "damage": 25, "damage_cooldown": 7, "zenny": 325, "HRpoints": 55,"path": "res://images/Anjanath.png", "Locale": "Ancient Forest"}
	},
]

# Called when the node enters the scene tree for the first time.
func _ready():
	Data.MonstersUnlocked.connect(BatchMerge)


func BatchMerge(batchnumber):
	monsters.merge(batches[batchnumber - 1])
	
#The simple button that removes HP from the monster
func _on_Monster_pressed():
	var random_number = randi_range(1, 100)
	var amount = Data.damage["Raw"]["Damage_amount"]
	if random_number <= Data.damage["Affinity"]["Amount"]:
		amount *= 1.25
		
		$Icon.global_position = get_global_mouse_position()
		print("Critical Hit!")
	Damage(amount)


#Damages the monster by clicking on it
func Damage(damageamount):
	health -= damageamount
	print("%s" % health)
	Healthbar.value = health
	if health <= 0:
		Data.Hunterrank(monsters[rand_monster]["HRpoints"])
		Reset()
		Money()
		

#Function that handles when a monster dies and is replaced by a new one
func Reset():
	Rand_Monster()
	print (rand_monster)
	#Sets the random given key to a value variable so it can be easily accessed 
	value = monsters[rand_monster]
	#Scales the difficulty
	Data.add_diff_scale(difficulty)
	#Sets the healthbar to the new given HP value
	health = value["health"] * (Data.difficulty_scale * 0.2)
	Healthbar.max_value = health
	Healthbar.value = health
	hunter_node = get_parent().hunters
	if hunter_node.hunter_amount > 0:
		DamageTimer.start(value["damage_cooldown"])
	print ("Max HP = %s" % health)
	#Sets the image for a new monster
	Monster_Button.set_texture_normal(load(value["path"])) 
	change_locale.emit(value["Locale"])

func Money():
	#Scales the money with the difficulty scaling
	value = monsters[rand_monster]
	Data.add_money(value["zenny"] * (Data.difficulty_scale * 0.5))

#Randomizes a monster from a dictionary and returns said monster
func Rand_Monster():
	rand_monster = monsters.keys()[randi() % monsters.size()]
	return rand_monster

#Checks which hunter does the most DPS and damage that hunter
func _on_timer_timeout():
	var damage_checker = 0
	for i in Data.hunters:
		if Data.hunters[i]["Damage"] >= damage_checker:
			damage_checker = Data.hunters[i]["Damage"]
			hunter = i
			Data.hunters[i]["Damage"] = 0 
	Data.hunters[hunter]["Health"] -= value["damage"] 
	damage_hunter.emit(hunter)
	
