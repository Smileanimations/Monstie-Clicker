extends Node
#Dictionary that holds all the sounds that plays
const SOUNDS = {
	"NewUnlocked": preload("res://sounds/soundfiles/ItemFound(rarest).mp3"),
	"TenRanksUp": preload("res://sounds/soundfiles/TenHunterRanksUp.mp3"),
	"HunterRankUp": preload("res://sounds/soundfiles/HunterRankUp.mp3"),
	"Purchase": preload("res://sounds/soundfiles/Purchase.wav"),
	"PurchasedHunter": preload("res://sounds/soundfiles/CombineItem.mp3")
}

#Plays the sounds in the queue
var queue_player : AudioStreamPlayer = AudioStreamPlayer.new()
#Hold the sound that need to be played in a queue
var sound_queue : Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#connects the signal when audio is finished playing and plays the next sound in the queue
	queue_player.finished.connect(play_queue)
	#adds it as child 
	get_tree().root.add_child.call_deferred(queue_player)



#a function that expects a string to be passed
func queue_sound(sound : String) -> void:
	#if the string is in the audio dictionary add the sound to the queue
	if sound in SOUNDS:
		#adds the sound to the queue
		sound_queue.append(sound)
		#if nothing in the queue is playing, start playing current sound in the queue
		if !queue_player.playing:
			play_queue()

#function that plays the sounds in the queue
func play_queue() -> void:
	#If there is a sound in the queue play that sound and remove it from the sound_queue array
	if sound_queue:
		queue_player.stream = SOUNDS[sound_queue.pop_front()]
		queue_player.play()

#function that plays audio without having to be in the queue
func play_audio(sound : String) -> void:
	#checks if the string is in the audio dictionary
	if sound in SOUNDS:
		#adds a new audio player
		var player : AudioStreamPlayer = AudioStreamPlayer.new()
		#connects to the kill_sound function the audio player to prevent it from building up everytime a sound is played
		player.finished.connect(kill_sound.bind(player))
		#adds the sound to the audioplayer
		player.stream = SOUNDS[sound]
		#adds it to the scene tree and plays the audio
		get_tree().root.add_child(player)
		player.play()

#clears the sound when its done playing
func kill_sound(sound : AudioStreamPlayer) -> void:
	sound.queue_free()
