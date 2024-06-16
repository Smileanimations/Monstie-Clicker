extends Node
var zenny : int = 10000
var damage = 10
var affinity : int = 0
var difficulty_scale =  1
var hunter_rank : int = 0
var elements = {
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
	damage += amount
	update_stat_display.emit()
#Adds the given amount of affinity and updates in on the display
func add_affinity(amount):
	affinity += amount
	update_stat_display.emit()
#Adds the given amount of difficulty and updates in on the display
func add_diff_scale(amount):
	difficulty_scale = difficulty_scale + amount
	update_stat_display.emit()
