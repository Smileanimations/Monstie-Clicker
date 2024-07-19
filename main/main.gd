extends Control
@onready var Zenny_display = $ZennyDisp
@onready var Points_Display = $PointsDisp
@onready var Stats_display = $Stats
@onready var monster = $monster
@onready var hunters = $hunters
@onready var shop = $shop
@onready var background = $background
@onready var xpbar = $XPbar
var current_zenny : int
var current_points : int
# Called when the node enters the scene tree for the first time.
func _ready():
	#Sets the zenny display
	Zenny_display.text = ("%sz" % Data.zenny)
	Points_Display.text = ("%sp" % Data.points)
	Stats_display.text = ("
	Damage = %s
	Affinity = %s%%
	Difficulty Scale = %s
	Hunter Rank = %s" % [Data.damage.Raw.Damage_amount, Data.damage.Affinity.Amount, Data.difficulty_scale, Data.hunter_rank])
	#Recieves a signal everytime zenny amount is updated 
	Data.update_stat_display.connect(updatestatdisp)
	set_connections()
	current_zenny = Data.zenny
	#Randomizes monster on startup
	monster.Reset()

func _process(delta):
	if current_zenny != Data.zenny:
		current_zenny = lerp(current_zenny, Data.zenny, delta * 10)
		Zenny_display.text = ("%sz" % current_zenny)
	if current_points != Data.points:
		current_points = lerp(current_points, Data.points, delta * 15)
		Points_Display.text = ("%sp" % current_points)
	if xpbar.value < Data.hunterrankpoints:
			xpbar.value = clamp(xpbar.value + (delta * 100), 0, Data.hunterrankpoints)


func set_connections():
	monster.change_locale.connect(background.BackgroundChange)

#Updates the display that shows all the statistics
func updatestatdisp():
	if Data.hunterrankpoints == 0:
		xpbar.value = 0
	xpbar.max_value = Data.hunter_rankxp
	Stats_display.text = ("
	Damage = %s
	Affinity = %s%%
	Difficulty Scale = %s
	Hunter Rank = %s" % [Data.damage.Raw.Damage_amount, Data.damage.Affinity.Amount, Data.difficulty_scale, Data.hunter_rank])
