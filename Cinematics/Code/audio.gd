extends Node3D
class_name CinematicSoundManager

var vfx_streams : Array[AudioStreamPlayer3DExtended]
var voice_streams : Array[AudioStreamPlayer3DExtended]



const WOSH = preload("uid://brrkf652nyyd2")
const STEPS = preload("uid://gr8i588iff4d")
const APPLAUSE = preload("uid://doqni0cbk6qbl")
const SHOT_MAGIC = preload("uid://c5llbi6s3o8mw")
const BELLS_C = preload("uid://5y2jbwyvhym7")
const BELLS_E = preload("uid://dbtd33l26jg23")
const BELLS_G = preload("uid://dqf626eepcxya")
const HUNGRY = preload("uid://crohdcud6o2bb")
const OPEN_LETTER = preload("uid://4xohg3rxkmqy")


func _ready() -> void:
	create_vfx_streamss()
	create_voice_stream()

func create_vfx_streamss() -> void:
	for i in range(20):
		var new_vfx_streams = AudioStreamPlayer3DExtended.new()
		new_vfx_streams.bus = "VFX"
		new_vfx_streams.name = "VFX_Stream" + str(i)
		vfx_streams.append(new_vfx_streams)
		add_child(new_vfx_streams)

func create_voice_stream() -> void:
	for i in range(5):
		var new_voice_streams = AudioStreamPlayer3DExtended.new()
		new_voice_streams.bus = "Voices"
		new_voice_streams.name = "VoiceStream" + str(i)
		new_voice_streams.volume_db = -8.0
		new_voice_streams.pitch_scale = 1.05
		#new_voice_streams.pitch_scale = 1.2
		voice_streams.append(new_voice_streams)
		add_child(new_voice_streams)


func shot_fx_sound(stream_name: String) -> void:
	var current_voice_stream : AudioStreamPlayer3DExtended = _get_avaialble_vfx_stream()
	if not current_voice_stream: return
	current_voice_stream.shot_sound(_get_audio_stream(stream_name))

func shot_voice_sound(stream_name: String) -> void:
	var current_voice_stream : AudioStreamPlayer3DExtended = _get_avaialble_voice_stream()
	if not current_voice_stream: return
	current_voice_stream.shot_sound(_get_audio_stream(stream_name))

const BREATH = preload("uid://jiopl8b1p8ku")
const COMPLAINT = preload("uid://bmntbbq3gxqxk")
const EFFORT = preload("uid://gqtqdib0vrbj")
const MMJM = preload("uid://cd3b4hn0p33n2")
const SURPRICE = preload("uid://doydvppu8oufv")
const THINKING_ABOUT = preload("uid://bguy014bm3qha")
const WAKE = preload("uid://bfd1o5beecs1w")
const YAWN = preload("uid://v6mxrjtk8rcx")

func _get_audio_stream(stream_name: String) -> AudioStream:
	match stream_name:
		"yawn":
			return YAWN
		"wake":
			return WAKE
		"thinking_about":
			return THINKING_ABOUT
		"surprice":
			return SURPRICE
		"mmjm":
			return MMJM
		"effort":
			return EFFORT
		"complaint":
			return COMPLAINT
		"breath":
			return BREATH
		"open_letter":
			return OPEN_LETTER
		"hungry":
			return HUNGRY
		"bells_g":
			return BELLS_G
		"bells_e":
			return BELLS_E
		"bells_c":
			return BELLS_C
		"shot_magic":
			return SHOT_MAGIC
		"applause":
			return APPLAUSE
		"steps":
			return STEPS
		"wosh":
			return WOSH
	return null

func _get_avaialble_vfx_stream() -> AudioStreamPlayer3DExtended:
	for vfx_stream in vfx_streams:
		if vfx_stream.available:
			return vfx_stream
	return null

func _get_avaialble_voice_stream() -> AudioStreamPlayer3DExtended:
	for voice_stream in voice_streams:
		if voice_stream.available:
			return voice_stream
	return null
