extends TextureRect

var background_images = {
	"Ancient Forest" = preload("res://images/Background Images/Ancient Forest.png"),
	"Wildspire Waste" = preload("res://images/Background Images/Wildspire Waste.png"),
	"Coral Highlands" = preload("res://images/Background Images/Coral Highlands.png"),
	"Rotten Vale" = preload("res://images/Background Images/Rotten Vale.png"),
	"Elders Recess" = preload("res://images/Background Images/Elders Recess.png")
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func BackgroundChange(locale):
	texture = background_images[locale]
