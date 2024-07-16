extends TextureButton
var item
signal item_hover
# Called when the node enters the scene tree for the first time.
func _ready():
	if Data.iteminventory[item]["Star"] == true:
		$Sprite2D.visible = true

func _on_mouse_entered():
	item_hover.emit(item)
