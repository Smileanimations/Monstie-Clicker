extends Control
@onready var Zenny_display = $ZennyDisp
@onready var Stats_display = $Stats
@onready var monster = $monster
# Called when the node enters the scene tree for the first time.
func _ready():
	#Sets the zenny display
	Zenny_display.text = ("%sz" % Data.zenny)
	Stats_display.text = ("
	Damage = %s
	Affinity = %s%%
	Difficulty Scale = %s
	Hunter Rank = %s" % [Data.damage.Raw.Damage_amount, Data.damage.Affinity.Amount, Data.difficulty_scale, Data.hunter_rank])
	#Recieves a signal everytime zenny amount is updated 
	Data.zenny_updated.connect(updatezennydisp)
	Data.update_stat_display.connect(updatestatdisp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#Updates the zenny amount in the top left corner
func updatezennydisp():
	Zenny_display.text = ("%sz" % Data.zenny)

#Updates the display that shows all the statistics
func updatestatdisp():
	Stats_display.text = ("
	Damage = %s
	Affinity = %s%%
	Difficulty Scale = %s
	Hunter Rank = %s" % [Data.damage.Raw.Damage_amount, Data.damage.Affinity.Amount, Data.difficulty_scale, Data.hunter_rank])
