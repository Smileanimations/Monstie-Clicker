extends TextureButton
var item
# Called when the node enters the scene tree for the first time.
func _ready():
	if Data.iteminventory[item]["Star"] == true:
		$Sprite2D.visible = true
