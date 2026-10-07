extends AudioStreamPlayer
class_name GameMusicManager


const _01_FOREST_ADVENTURE : String = "uid://d2jdo1t7bvmch"
const _02_ROCKY_PEAKS : String = "uid://dranq5msvrhef"

func _ready() -> void:
	play_next_song()
	GlobalSignals.stop_current_song.connect(stop_current_song)
	GlobalSignals.play_next_song.connect(play_next_song)

func play_next_song() -> void:
	var current_stream : AudioStream 
	if not CurrentGamePersistence.current_game_data["KornObtained"]:
		current_stream = load(_01_FOREST_ADVENTURE)
	elif not CurrentGamePersistence.current_game_data["CheeseObtained"]:
		current_stream = load(_02_ROCKY_PEAKS)
	elif not CurrentGamePersistence.current_game_data["CoffeObtained"]:
		current_stream = load(_02_ROCKY_PEAKS)
	else:
		pass
	volume_db = -10.0
	stream = current_stream
	play()

func stop_current_song() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(self, "volume_db", -80.0, 0.5)
	await tween.finished
	stop()
