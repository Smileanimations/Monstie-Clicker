extends Control
var number = 0
var current_hunter
@onready var monster
@onready var hunters = {
	"Hunter1": {"Weapon": Data.weapons["Greatsword"], "Path": $HBoxContainer/Hunter1, "Timer": $HBoxContainer/Hunter1/Timer},
	"Hunter2": {"Weapon": Data.weapons["Sword And Shield"], "Path": $HBoxContainer/Hunter2, "Timer": $HBoxContainer/Hunter2/Timer},
	"Hunter3": {"Weapon": Data.weapons["Dual Blades"], "Path": $HBoxContainer/Hunter3, "Timer": $HBoxContainer/Hunter3/Timer},
	"Hunter4": {"Weapon": Data.weapons["Longsword"], "Path": $HBoxContainer/Hunter4, "Timer": $HBoxContainer/Hunter4/Timer}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	Data.PurchasedHunter.connect(AddHunter)
	current_hunter = hunters.keys()
	await(get_parent().ready)
	monster = get_parent().monster
	

#When a hunter is purchased sets the weapon and sets it on screen
func AddHunter():
	hunters[current_hunter[number]]["Path"].visible = true
	hunters[current_hunter[number]]["Path"].texture = load(hunters[current_hunter[number]]["Weapon"]["Path"])
	hunters[current_hunter[number]]["Timer"].start(hunters[current_hunter[number]]["Weapon"]["Cooldown"])
	number += 1


#When the weapon cooldown reaches zero calls the function that damages the monster
#Argument in this case is the name of the hunter e.g: Hunter1, Hunter2, Hunter3, Hunter4
func _on_timer_timeout(argument):
	var random_number = randi_range(1, 100)
	var amount = hunters[argument]["Weapon"]["Damage_amount"]
	if random_number <= hunters[argument]["Weapon"]["Affinity"]:
		amount *= 1.25
		print("Hunter Critical Hit!")
	#Calls the function that damages the monster
	monster.damage(amount)
	
