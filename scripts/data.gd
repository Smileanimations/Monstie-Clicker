extends Node
var zenny : int = 10000
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


signal zenny_updated
signal update_stat_display
# Called when the node enters the scene tree for the first time.
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
#Adds the given amount of difficulty and updates in on the display
func add_diff_scale(amount):
	difficulty_scale = difficulty_scale + amount
	update_stat_display.emit()
