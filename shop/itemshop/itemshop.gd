extends TextureButton
var item

# Called when the node enters the scene tree for the first time.
func _ready():
	if Data.iteminventory[item]["Star"] == true:
		$Sprite2D.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	pass # Replace with function body.
