extends AudioStreamPlayer

var SoundDictionary = {
	"NewUnlocked": preload("res://sounds/soundfiles/ItemFound(rarest).mp3"),
	"TenRanksUp": preload("res://sounds/soundfiles/TenRanksUp.mp3"),
	"HunterRankUp": preload("res://sounds/soundfiles/HunterRankUp.wav")
}

func playaudio(sound):
	stream = SoundDictionary[sound]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
