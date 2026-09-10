extends Node3D
class_name AudioManager

var vfx_streams : Array[AudioStreamPlayer3DExtended]
var voice_stream : AudioStreamPlayer3DExtended

func _ready() -> void:
	create_vfx_streamss()
	create_voice_stream()

func create_vfx_streamss() -> void:
	for i in range(10):
		var new_vfx_streams = AudioStreamPlayer3DExtended.new()
		new_vfx_streams.bus = "VFX"
		new_vfx_streams.name = "VFX_Stream" + str(i)
		vfx_streams.append(new_vfx_streams)
		add_child(new_vfx_streams)

func create_voice_stream() -> void:
	voice_stream = AudioStreamPlayer3DExtended.new()
	voice_stream.bus = "VFX"
	voice_stream.name = "VoiceStream"
	add_child(voice_stream)

#region Sounds


const HARD_IMPACT = preload("uid://twx041d7b7w6")
const HIT_WOSH = preload("uid://clcu6ixuub3kf")
const JUMP = preload("uid://b6s1ircoil1u2")
const STEPS = preload("uid://gr8i588iff4d")
const WOSH = preload("uid://brrkf652nyyd2")

const BELLS_C = preload("uid://5y2jbwyvhym7")
const BELLS_E = preload("uid://dbtd33l26jg23")
const BELLS_G = preload("uid://dqf626eepcxya")



func shot_step_sounds() -> void:
	var current_vfx_stream : AudioStreamPlayer3DExtended = _get_avaialble_vfx_stream()
	if not current_vfx_stream: return
	rand_stream(current_vfx_stream)
	current_vfx_stream.shot_sound(STEPS)

func shot_wosh_sound() -> void:
	var current_vfx_stream : AudioStreamPlayer3DExtended = _get_avaialble_vfx_stream()
	if not current_vfx_stream: return
	rand_stream(current_vfx_stream)
	current_vfx_stream.shot_sound(WOSH)

func shot_floor_impact(intensity: float) -> void:
	var current_vfx_stream : AudioStreamPlayer3DExtended = _get_avaialble_vfx_stream()
	if not current_vfx_stream: return
	rand_stream(current_vfx_stream)
	current_vfx_stream.volume_db = -5
	current_vfx_stream.shot_sound(HARD_IMPACT)

var current_bell_effect_chord : int = 1
func shot_bells_effect() -> void:
	var current_vfx_stream : AudioStreamPlayer3DExtended = _get_avaialble_vfx_stream()
	if not current_vfx_stream: return
	current_vfx_stream.volume_db = -5
	current_vfx_stream.pitch_scale = 1.0
	match current_bell_effect_chord:
		1:
			current_vfx_stream.shot_sound(BELLS_C)
		2:
			current_vfx_stream.shot_sound(BELLS_E)
		3:
			current_vfx_stream.shot_sound(BELLS_G)
	current_bell_effect_chord = current_bell_effect_chord + 1 
	if current_bell_effect_chord > 3:
		current_bell_effect_chord = 1

func rand_stream(current_vfx_stream: AudioStreamPlayer3DExtended) -> void:
	current_vfx_stream.pitch_scale = randf_range(0.8, 1.2)
	current_vfx_stream.volume_db = randf_range(0.8, 1.2)

#endregion

func _get_avaialble_vfx_stream() -> AudioStreamPlayer3DExtended:
	for vfx_stream in vfx_streams:
		if vfx_stream.available:
			return vfx_stream
	return null
