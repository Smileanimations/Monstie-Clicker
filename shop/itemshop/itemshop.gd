extends TextureButton
var item
signal item_hover
signal item_exit
signal item_purchased
# Called when the node enters the scene tree for the first time.
func _ready():
	if Data.iteminventory[item]["Star"] == true:
		$Sprite2D.visible = true
