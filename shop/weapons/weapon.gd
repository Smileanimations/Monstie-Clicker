extends TextureButton
var current_weapon
signal weapon_change(current_weapon)

#Loads the weapon texture and weapon
func LoadWeapons(weapon):
	texture_normal = load(weapon["Path"])
	current_weapon = weapon

#Emits a signal that changes the weapon of the hunter and the icon in the manage hunter tab
func _on_pressed():
	weapon_change.emit(current_weapon)
