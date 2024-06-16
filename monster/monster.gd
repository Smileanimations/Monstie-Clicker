extends Control
var value
var rand_monster
var health = 0
var difficulty = 0.2
@onready var Monster_Button = $Monster
@onready var Healthbar = $Healthbar


#A Dictionary containing all current monsters
var monsters = {
	"Kulu-Ya-Ku": {"health":100, "zenny": 90, "path": "res://images/Kulu.png"},
	"Tzitzi-Ya-Ku": {"health": 125, "zenny":100, "path": "res://images/Tzitzi.png"},
	"Great Jagras": {"health": 150, "zenny": 100, "path": "res://images/Jagras.png"},
	"Great Girros": {"health": 150, "zenny": 100, "path": "res://images/Girros.png"},
	"Jyuratodus": {"health":200, "zenny": 110, "path": "res://images/Jyuratodus.png"},
	"Dodogama": {"health": 225, "zenny": 120, "path": "res://images/Dodogama.png"},
	"Pukei-Pukei": {"health":250, "zenny": 130, "path": "res://images/Pukei.png"},
	"Tobi-Kadachi": {"health":275, "zenny": 150, "path": "res://images/Tobi.png"},
	"Barroth": {"health":300, "zenny": 140, "path": "res://images/Barroth.png"},
}


# Called when the node enters the scene tree for the first time.
func _ready():
	#Randomizes monster on startup
	Reset()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#The simple button that removes HP from the monster
func _on_Monster_pressed():
	damage(Data.damage)
	if health <= 0:
		Reset()
		Money()

#Damages the monster by clicking on it
func damage(damage):
	#Randomizes a number between the amount of purchased affinity upgrades and 100
	var random_number = randi_range(1, 100)
	var amount = damage
	#If the random number is less than the affinity the next attack is increased with 25%
	if random_number <= Data.affinity:
		amount *= 1.25
		print("Critical Hit!")
	health -= amount
	round(health)
	print("%s" % health)
	Healthbar.value = health

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
