extends Control
var amount
@onready var hunters = {
	"Hunter1": {"Weapon": Data.weapons["Greatsword"], "Path": $HBoxContainer/Hunter1},
	"Hunter2": {"Weapon": null , "Path": $HBoxContianer/Hunter2},
	"Hunter3": {"Weapon": null , "Path": $HBoxContainer/Hunter3},
	"Hunter4": {"Weapon": null , "Path": $HBoxContainer/Hunter4}
}


# Called when the node enters the scene tree for the first time.
func _ready():
	Data.PurchasedHunter.connect(AddHunter)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func AddHunter():
	hunters["Hunter1"]["Path"].visible = true
	hunters["Hunter1"]["Path"].texture = load(hunters["Hunter1"]["Weapon"]["Path"])
	weapon_attack(hunters["Hunter1"]["Weapon"])

func weapon_attack(weapon):
	amount = weapon["Damage_amount"]
	print(amount)
