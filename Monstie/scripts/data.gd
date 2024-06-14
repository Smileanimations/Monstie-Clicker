extends Node
var zenny = 0
var damage = 10
var difficulty_scale = 1
var hunter_rank = 0
signal zenny_updated

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#Function that emits a signal when zenny amount is updated
func add_money(amount):
	zenny += amount
	zenny_updated.emit()

func subtract_money(amount):
	zenny -= amount
	zenny_updated.emit()
