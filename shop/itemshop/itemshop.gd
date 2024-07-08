extends Panel
@onready var Cont = $HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in Data.iteminventory:
		print(i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
