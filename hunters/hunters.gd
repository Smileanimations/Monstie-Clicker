extends Control
var current_hunter
@onready var monster 
@onready var hunterpanel
@onready var paths = {
	"Hunter1": {"Path": $HBoxContainer/Hunter1, "Timer": $HBoxContainer/Hunter1/Timer},
	"Hunter2": {"Path": $HBoxContainer/Hunter2, "Timer": $HBoxContainer/Hunter2/Timer},
	"Hunter3": {"Path": $HBoxContainer/Hunter3, "Timer": $HBoxContainer/Hunter3/Timer},
	'Hunter4': {"Path": $HBoxContainer/Hunter4, "Timer": $HBoxContainer/Hunter4/Timer}
}
# Called when the node enters the scene tree for the first time.
func _ready():
	Data.PurchasedHunter.connect(AddHunter)
	await(get_parent().ready)
	monster = get_parent().monster
	#Gets the nodes from weapon group and calls the function that loops through them
	var hunterpanel = get_tree().get_nodes_in_group("WeaponGroup")
	Hunterpanel(hunterpanel)
	

#When a hunter is purchased sets the weapon and sets it on screen
func AddHunter(hunters):
	Data.hunters[hunters].merge(paths[hunters])
	Data.hunters[hunters]["Path"].visible = true
	Data.hunters[hunters]["Path"].texture = load(Data.hunters[hunters]["Weapon"]["Path"])
	#Starts the timer for the weapon cooldown
	Data.hunters[hunters]["Timer"].start(Data.hunters[hunters]["Weapon"]["Cooldown"])
	current_hunter = hunters


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

#Connects each hunter node to the WeaponUpdated function
func Hunterpanel(hunters):
	for hunter in hunters:
		hunter.weapon_changed.connect(WeaponUpdated)

#Changes the weapon based on which hunters requests a weapon change
func WeaponUpdated(weapon, hunter):
	print(hunter)
	print(weapon)
	Data.hunters[hunter]["Weapon"] = weapon
	Data.hunters[hunter]["Path"].texture = load(weapon["Path"])
	Data.hunters[hunter]["Timer"].start(weapon["Cooldown"])
