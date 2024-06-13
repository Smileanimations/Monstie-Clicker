extends Control
var difficulty_scale = 1
var value
var rand_monster
var damage_amount = 14
var money = 0
var health = 100
@onready var Monster_Button = $Monster
@onready var Healthbar = $Healthbar
@onready var money_display = $Moneydisp

#A Dictionary containing all current monsters
var monsters = {
	"Great Jagras": {"health": 250, "zenny": 100, "path": "res://images/Jagras.png"},
	"Kulu-Ya-Ku": {"health":200, "zenny": 90, "path": "res://images/Kulu.png"},
	"Pukei-Pukei": {"health":350, "zenny": 130, "path": "res://images/Pukei.png"},
	"Tobi-Kadachi": {"health":375, "zenny": 150, "path": "res://images/Tobi.png"},
	"Barroth": {"health":400, "zenny": 140, "path": "res://images/Barroth.png"},
	"Jyuratodus": {"health":300, "zenny": 110, "path": "res://images/Jyuratodus.png"},
}


# Called when the node enters the scene tree for the first time.
func _ready():
	#Displays the amount of money you have in the top left corner
	money_display.text = "Zenny: %s" % money
	Reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#The simple button that removes HP from the monster
func _on_Monster_pressed():
	damage(damage_amount)
	if health <= 0:
		Reset()
		Money()

#Damages the monster by clicking on it
func damage(damage):
	health -= damage
	print("%s" % health)
	Healthbar.value = health

#Function that handles when a monster dies and is replaced by a new one
func Reset():
	Rand_Monster()
	print (rand_monster)
	#Sets the random given key to a value variable so it can be easily accessed 
	value = monsters[rand_monster]
	#Scales the difficulty and amount of zenny gained
	difficulty_scale = difficulty_scale + 0.2
	#Sets the healthbar to the new given HP value
	health = value["health"] * difficulty_scale
	Healthbar.max_value = health
	Healthbar.value = health
	print ("Max HP = %s" % health)
	#Sets the image for a new monster
	Monster_Button.set_texture_normal(load(value["path"])) 

#Function that handles all the Zenny income
func Money():
	#Scales the money with the difficulty scaling
	value = monsters[rand_monster]
	money += value["zenny"] * difficulty_scale
	#Displays the money in the top left corner of the screen
	money_display.text = "Zenny: %s" % money
	print ("Zenny = %s" % money)

#Randomizes a monster from a dictionary and returns said monster
func Rand_Monster():
	rand_monster = monsters.keys()[randi() % monsters.size()]
	return rand_monster