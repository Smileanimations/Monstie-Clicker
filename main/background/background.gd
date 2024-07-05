extends TextureRect
@onready var background

var background_images = {
	"Ancient Forest" = "res://images/Background Images/Ancient Forest.png",
	"Wildspire Waste" = "res://images/Background Images/Wildspire Waste.png",
	"Coral Highlands" = "res://images/Background Images/Coral Highlands.png",
	"Rotten Vale" = "res://images/Background Images/Rotten Vale.png",
	"Elders Recess" = "res://images/Background Images/Elders Recess.png"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	await(get_parent().ready)
	var monster_node = get_parent().monster
	monster_node.change_locale.connect(BackgroundChange)

func BackgroundChange(locale):
	texture = load(background_images[locale])
