extends Control
var value
var rand_monster
var health = 100
var difficulty = 0.2
@onready var Monster_Button = $Monster
@onready var Healthbar = $Healthbar


#A Dictionary containing all current monsters
var monsters = {
	"Kulu-Ya-Ku": {"health":100, "zenny": 90, "HRpoints": 5,"path": "res://images/Kulu.png"},
	"Tzitzi-Ya-Ku": {"health": 125, "zenny":100, "HRpoints": 5,"path": "res://images/Tzitzi.png"},
	"Great Jagras": {"health": 150, "zenny": 100, "HRpoints": 10,"path": "res://images/Jagras.png"},
	"Great Girros": {"health": 150, "zenny": 100, "HRpoints": 10,"path": "res://images/Girros.png"},
	"Jyuratodus": {"health":200, "zenny": 110, "HRpoints": 15,"path": "res://images/Jyuratodus.png"},
	"Dodogama": {"health": 225, "zenny": 120, "HRpoints": 15,"path": "res://images/Dodogama.png"},
	"Pukei-Pukei": {"health":250, "zenny": 130, "HRpoints": 20,"path": "res://images/Pukei.png"},
	"Tobi-Kadachi": {"health":275, "zenny": 150, "HRpoints": 20,"path": "res://images/Tobi.png"},
	"Barroth": {"health":300, "zenny": 140, "HRpoints": 25,"path": "res://images/Barroth.png"},
}

var batches = [
	{
		"Paolumu": {"health": 325, "zenny": 150, "HRpoints": 40,"path": "res://images/Paolumu.png"},
		"Rathian": {"health": 350, "zenny": 175, "HRpoints": 45,"path": "res://images/Rathian.png"},
		"Radobaan": {"health": 375, "zenny": 200, "HRpoints": 40,"path": "res://images/Radobaan.png"},
		"Anjanath": {"health": 400, "zenny": 225, "HRpoints": 45,"path": "res://images/Anjanath.png"}
	}
]

# Called when the node enters the scene tree for the first time.
func _ready():
	Data.MonstersUnlocked.connect(BatchMerge)
	#Randomizes monster on startup
	Reset()

func BatchMerge(batchnumber):
	monsters.merge(batches[batchnumber - 1])
	
#The simple button that removes HP from the monster
func _on_Monster_pressed():
	var random_number = randi_range(1, 100)
	var amount = Data.damage["Raw"]["Damage_amount"]
	if random_number <= Data.damage["Affinity"]["Amount"]:
		amount *= 1.25
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
	health = value["health"] * Data.difficulty_scale
	Healthbar.max_value = health
	Healthbar.value = health
	print ("Max HP = %s" % health)
	#Sets the image for a new monster
	Monster_Button.set_texture_normal(load(value["path"])) 

func Money():
	#Scales the money with the difficulty scaling
	value = monsters[rand_monster]
	Data.add_money(value["zenny"] * Data.difficulty_scale)

#Randomizes a monster from a dictionary and returns said monster
func Rand_Monster():
	rand_monster = monsters.keys()[randi() % monsters.size()]
	return rand_monster
