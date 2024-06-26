extends TextureButton
var current_weapon
signal weapon_changed(current_weapon)

#Loads the weapon texture and weapon
func LoadWeapons(weapon):
	texture_normal = load(weapon["Path"])
	print(weapon)
	current_weapon = weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


#Emits a signal that changes the weapon of the hunter and the icon in the manage hunter tab
func _on_pressed():
	weapon_changed.emit(current_weapon)
