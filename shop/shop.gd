extends Control
var price_atb : int = 100
var price_aff : int = 500
var price_hunter : int = 2000
@onready var Attackbutton = $Panel/AttackUp
@onready var Affinitybutton = $Panel/AffinityUp
@onready var Elementpopup = $Panel/ElementUp/Popup
@onready var AddHunterbutton = $Panel/AddHunter
@onready var ElementalButtons = {
	"Fire": {"Price": 200, "Path": $Panel/ElementUp/Popup/VBoxContainer/FireUp},
	"Ice": {"Price": 200,"Path": $Panel/ElementUp/Popup/VBoxContainer/IceUp},
	"Thunder": {"Price": 200,"Path": $Panel/ElementUp/Popup/VBoxContainer/ThunderUp},
	"Water": {"Price": 200,"Path": $Panel/ElementUp/Popup/VBoxContainer/WaterUp},
	"Dragon": {"Price": 200,"Path": $Panel/ElementUp/Popup/VBoxContainer/DragonUp}
}
 
# Called when the node enters the scene tree for the first time.
func _ready():
	Attackbutton.text = "Increase Attack - %s" % price_atb
	Affinitybutton.text = "Increase Affinity - %s" % price_aff
	AddHunterbutton.text = "Add Hunter - %d" % price_hunter

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#When you purchase an Attack Boost functions from data.gd get called to subtract the money and add the damage
func _on_attack_up_pressed():
	var damage_amount = 2.5
	if Data.zenny >= price_atb:
		Data.subtract_money(price_atb)
		Data.add_damage(damage_amount)
		price_atb += 300
		Attackbutton.text = "Increase Attack - %s" % price_atb



func _on_affinity_up_pressed():
	var affinity_amount = 1
	if Data.zenny >= price_aff:
		Data.subtract_money(price_aff)
		Data.add_affinity(affinity_amount)
		price_aff += price_aff * 2
		Affinitybutton.text = "Increase Affinity - %s" % price_aff


#Pops up a window containing all elemental buttons
func _on_element_up_pressed():
	Elementpopup.popup()

func _on_element_button_pressed(element):
	var element_amount = 2
	print("%s" % ElementalButtons[element]["Price"])
	if Data.zenny >= ElementalButtons[element]["Price"]:
		Data.subtract_money(ElementalButtons[element]["Price"])
		Data.add_element(element, element_amount)
		Data.damage[element]["Damage_amount"] += 2
		ElementalButtons[element]["Price"] = int(ElementalButtons[element]["Price"] * 1.5)
		ElementalButtons[element]["Path"].text = "Increase %s Dmg - %s" % [element, ElementalButtons[element]["Price"]]
	


func _on_add_hunter_pressed():
	if Data.zenny >= price_hunter:
		Data.subtract_money(price_hunter)
		price_hunter = price_hunter * 10
		AddHunterbutton.text = "Add Hunter - %d" % price_hunter
