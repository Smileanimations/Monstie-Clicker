extends Control
var number = 0
var current_hunter
@onready var monster 
@onready var paths = {
	"Hunter1": {"Path": $HBoxContainer/Hunter1, "Timer": $HBoxContainer/Hunter1/Timer},
	"Hunter2": {"Path": $HBoxContainer/Hunter2, "Timer": $HBoxContainer/Hunter2/Timer},
	"Hunter3": {"Path": $HBoxContainer/Hunter3, "Timer": $HBoxContainer/Hunter3/Timer},
	'Hunter4': {"Path": $HBoxContainer/Hunter4, "Timer": $HBoxContainer/Hunter4/Timer}
}
# Called when the node enters the scene tree for the first time.
func _ready():
	Data.PurchasedHunter.connect(AddHunter)
	current_hunter = Data.hunters.keys()
	await(get_parent().ready)
	monster = get_parent().monster
	

#When a hunter is purchased sets the weapon and sets it on screen
func AddHunter():
	Data.hunters[current_hunter[number]].merge(paths[current_hunter[number]])
	Data.hunters[current_hunter[number]]["Path"].visible = true
	Data.hunters[current_hunter[number]]["Path"].texture = load(Data.hunters[current_hunter[number]]["Weapon"]["Path"])
	Data.hunters[current_hunter[number]]["Timer"].start(Data.hunters[current_hunter[number]]["Weapon"]["Cooldown"])
	number += 1


#When the weapon cooldown reaches zero calls the function that damages the monster
#Argument in this case is the name of the hunter e.g: Hunter1, Hunter2, Hunter3, Hunter4
func _on_timer_timeout(argument):
	var random_number = randi_range(1, 100)
	var amount = Data.hunters[argument]["Weapon"]["Damage_amount"] + Data.hunters[argument]["HunterDamage"]
	if random_number <= Data.hunters[argument]["Weapon"]["Affinity"] + Data.hunters[argument]["HunterAffinity"]:
		amount *= 1.25
		print("Hunter Critical Hit!")
	#Calls the function that damages the monster
	monster.damage(amount)
	

func Weaponupdated(weapon):
	Data.hunters["Hunter1"]["Path"].texture = load(weapon["Path"])
	Data.hunters["Hunter1"]["Timer"].start(weapon["Cooldown"])
