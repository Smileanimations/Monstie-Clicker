extends AudioStreamPlayer

var SoundDictionary = {
	"NewUnlocked": preload("res://sounds/soundfiles/ItemFound(rarest).mp3"),
	"TenRanksUp": preload("res://sounds/soundfiles/ItemFound(rare).mp3"),
	"HunterRankUp": preload("res://sounds/soundfiles/ItemFound.mp3")
}

func playaudio(sound):
	stream = SoundDictionary[sound]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
