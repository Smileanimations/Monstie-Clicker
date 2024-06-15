extends Node
var zenny = 10000
var damage = 10
var affinity = 50
var difficulty_scale = 1
var hunter_rank = 0
signal zenny_updated
signal update_stat_display
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#Function that emits a signal when zenny amount is updated
func add_money(amount):
	zenny += amount
	round(zenny)
	zenny_updated.emit()

func subtract_money(amount):
	zenny -= amount
	round(zenny)
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
