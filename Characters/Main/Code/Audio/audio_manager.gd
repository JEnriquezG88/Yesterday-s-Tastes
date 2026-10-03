extends Node3D
class_name AudioManager

var vfx_streams : Array[AudioStreamPlayer3DExtended]
var voice_streams : Array[AudioStreamPlayer3DExtended]

func _ready() -> void:
	create_vfx_streamss()
	create_voice_stream()
	GlobalSignals.is_stamp_sound.connect(_on_is_stamp_sound)

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

#region Sounds


const HARD_IMPACT = preload("uid://twx041d7b7w6")
const HIT_WOSH = preload("uid://clcu6ixuub3kf")
const JUMP = preload("uid://b6s1ircoil1u2")
const STEPS = preload("uid://gr8i588iff4d")
const WOSH = preload("uid://brrkf652nyyd2")

const BELLS_C = preload("uid://5y2jbwyvhym7")
const BELLS_E = preload("uid://dbtd33l26jg23")
const BELLS_G = preload("uid://dqf626eepcxya")

const CHARGE_MAGIC = preload("uid://c5l7tyvpds6c1")
const SHOT_MAGIC = preload("uid://c5llbi6s3o8mw")

const GET_INGREDIENTS = preload("uid://bwu3tvd74rjtg")


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

func shot_charge_magic_fx() -> void:
	var current_vfx_stream : AudioStreamPlayer3DExtended = _get_avaialble_vfx_stream()
	if not current_vfx_stream: return
	current_vfx_stream.volume_db = 0.0
	current_vfx_stream.pitch_scale = 1.0
	current_vfx_stream.shot_sound(CHARGE_MAGIC)

func shot_shot_magic_fx() -> void:
	var current_vfx_stream : AudioStreamPlayer3DExtended = _get_avaialble_vfx_stream()
	if not current_vfx_stream: return
	current_vfx_stream.volume_db = 0.0
	current_vfx_stream.pitch_scale = 1.0
	current_vfx_stream.shot_sound(SHOT_MAGIC)

func shot_get_ingredients_fx() -> void:
	var current_vfx_stream : AudioStreamPlayer3DExtended = _get_avaialble_vfx_stream()
	if not current_vfx_stream: return
	current_vfx_stream.volume_db = 0.0
	current_vfx_stream.pitch_scale = 1.0
	current_vfx_stream.shot_sound(GET_INGREDIENTS)


const FIRE = preload("uid://by47iq57r2epi")
const FREEZE = preload("uid://bvaq8erv8rh1b")
const RETURN = preload("uid://dulfwp3p2ws3o")
const STAMP = preload("uid://bin8f8kdi6d30")
const STONE = preload("uid://313it85j3u8d")
const UPS = preload("uid://br7iwixybbfp8")
const YEY = preload("uid://dvexcxuvjjc3")

var is_stamp_sound : bool = false

func _on_is_stamp_sound(value: bool) -> void:
	is_stamp_sound = value

func shot_magic_voice(magic: MagicSystem.MAGIC_TYPES) -> void:
	var current_voice_stream : AudioStreamPlayer3DExtended = _get_avaialble_voice_stream()
	if not current_voice_stream: return
	match magic:
		MagicSystem.MAGIC_TYPES.ICE:
			current_voice_stream.shot_sound(FREEZE)
		MagicSystem.MAGIC_TYPES.FIRE:
			current_voice_stream.shot_sound(FIRE)
		MagicSystem.MAGIC_TYPES.STAMP:
			current_voice_stream.shot_sound(STAMP)
		MagicSystem.MAGIC_TYPES.BROKE:
			if is_stamp_sound:
				is_stamp_sound = false
				current_voice_stream.shot_sound(STAMP)
			else:
				current_voice_stream.shot_sound(STONE)
		MagicSystem.MAGIC_TYPES.RETURN:
			current_voice_stream.shot_sound(RETURN)

func shot_ups_sound() -> void:
	var current_voice_stream : AudioStreamPlayer3DExtended = _get_avaialble_voice_stream()
	if not current_voice_stream: return
	current_voice_stream.shot_sound(UPS)

func shot_yey_sound() -> void:
	var current_voice_stream : AudioStreamPlayer3DExtended = _get_avaialble_voice_stream()
	if not current_voice_stream: return
	current_voice_stream.shot_sound(YEY)

func rand_stream(current_vfx_stream: AudioStreamPlayer3DExtended) -> void:
	current_vfx_stream.pitch_scale = randf_range(0.8, 1.2)
	current_vfx_stream.volume_db = randf_range(0.8, 1.2)

#endregion

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
