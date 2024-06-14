extends Control
var price_atb = 100
@onready var Attackbutton = $Panel/AttackUp

# Called when the node enters the scene tree for the first time.
func _ready():
	Attackbutton.text = "Increase Attack - %s" % price_atb


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_attack_up_pressed():
	if Data.zenny >= price_atb:
		Data.subtract_money(price_atb)
		purchase_atb()


func purchase_atb():
	Data.damage += 2
	price_atb += 100 * 1.2
	Attackbutton.text = "Increase Attack - %s" % price_atb
