extends Control
var price_atb : int = 100
var price_aff : int = 500
var price_hunter : int = 2000
var price_hunterdmg : int = 300
var hunters = 0
@onready var Attackbutton = $Panel/AttackUp
@onready var Affinitybutton = $Panel/AffinityUp
@onready var Elementpopup = $Panel/ElementUp/Popup
@onready var AddHunterbutton = $Panel/AddHunter
@onready var ManageHunterpanel = $Panel/AddHunter/PopupPanel
@onready var HunterAttackUpbutton = $"Panel/AddHunter/PopupPanel/ManageHunters/Hunter 1/HunterAttackUp"
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

#When you purchase an Attack Boost, functions from data.gd get called to subtract the money and add the damage
func _on_attack_up_pressed():
	#Adds 2.5 to your raw damage
	var damage_amount = 2.5
	if Data.zenny >= price_atb:
		Data.subtract_money(price_atb)
		Data.add_damage(damage_amount)
		#Sets the price increase for the next purchase 
		price_atb += 300
		Attackbutton.text = "Increase Attack - %s" % price_atb


#When you purchase an Affinity Boost, functions from data.gd get called to subtract the money and add the affinity
func _on_affinity_up_pressed():
	#Adds 1% affinity
	var affinity_amount = 1
	if Data.zenny >= price_aff:
		Data.subtract_money(price_aff)
		Data.add_affinity(affinity_amount)
		#Sets the price increase for the next purchase 
		price_aff += price_aff * 2
		Affinitybutton.text = "Increase Affinity - %s" % price_aff


#Pops up a window containing all elemental buttons
func _on_element_up_pressed():
	Elementpopup.popup()
#Adds the corospondent element which you purchased to the damage array
func _on_element_button_pressed(element):
	#Adds 2 elemental damage 
	var element_amount = 2
	print("%s" % ElementalButtons[element]["Price"])
	if Data.zenny >= ElementalButtons[element]["Price"]:
		Data.subtract_money(ElementalButtons[element]["Price"])
		Data.add_element(element, element_amount)
		Data.damage[element]["Damage_amount"] += 2
		#Sets the price increase for the next purchase 
		ElementalButtons[element]["Price"] = int(ElementalButtons[element]["Price"] * 1.5)
		ElementalButtons[element]["Path"].text = "Increase %s Dmg - %s" % [element, ElementalButtons[element]["Price"]]
	

#Sets the price for the next hunter purchased. Does not set the hunter themselves
func _on_add_hunter_pressed():
	if hunters == 1:
		ManageHunterpanel.visible = true
	else:
		if Data.zenny >= price_hunter:
			Data.subtract_money(price_hunter)
			#Calls a function which sends a signal to hunters.gd
			Data.AddedHunter()
			#Sets the price increase for the next purchase 
			price_hunter = price_hunter * 10
			hunters += 1
			AddHunterbutton.text = "Manage Hunters"


func _on_hunter_attack_up_pressed(argument):
	if Data.zenny >= price_hunterdmg:
		Data.subtract_money(price_hunterdmg)
		Data.add_hunterdamage(argument)
		price_hunterdmg = price_hunterdmg + 400
		HunterAttackUpbutton.text = "Increase Attack - %s" % price_hunterdmg
	
