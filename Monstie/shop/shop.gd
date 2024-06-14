extends Control
var price_atb = 100
var price_aff = 500
@onready var Attackbutton = $Panel/AttackUp
@onready var Affinitybutton = $Panel/AffinityUp

# Called when the node enters the scene tree for the first time.
func _ready():
	Attackbutton.text = "Increase Attack - %s" % price_atb
	Affinitybutton.text = "Increase Affinity - %s" % price_aff

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_attack_up_pressed():
	if Data.zenny >= price_atb:
		Data.subtract_money(price_atb)
		Data.damage += 2.5
		price_atb += 100 * 1.5
		Attackbutton.text = "Increase Attack - %s" % price_atb
		


func _on_affinity_up_pressed():
	if Data.zenny >= price_aff:
		Data.subtract_money(price_aff)
		Data.affinity += 1
		price_aff += 500 + (price_aff * 2)
		Affinitybutton.text = "Increase Affinity - %s" % price_aff
