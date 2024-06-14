extends Control
@onready var Zenny_display = $ZennyDisp

# Called when the node enters the scene tree for the first time.
func _ready():
	#Sets the zenny display
	Zenny_display.text = ("Zenny = %s" % Data.zenny)
	#Recieves a signal everytime zenny amount is updated 
	Data.zenny_updated.connect(updatedisp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#Updates the zenny amount in the top left corner
func updatedisp():
	Zenny_display.text = ("Zenny = %s" % Data.zenny)


