extends Node3D
class_name InteractionObjectSoundManager

var audio_fx_stream : Array[AudioStreamPlayer3DExtended] = []

func _ready() -> void:
	for i in range(3):
		var new_audio_fx_stream : AudioStreamPlayer3DExtended = AudioStreamPlayer3DExtended.new()
		new_audio_fx_stream.name = "AudioFXStream_" + str(i)
		new_audio_fx_stream.bus = "VFX"
		new_audio_fx_stream.volume_db = -3.0
		audio_fx_stream.append(new_audio_fx_stream)
		add_child(new_audio_fx_stream)

func shot_sound(stream: AudioStream) -> void:
	var current_audio_stream : AudioStreamPlayer3DExtended = _get_avaialble_voice_stream()
	if not current_audio_stream: return
	current_audio_stream.shot_sound(stream)

func _get_avaialble_voice_stream() -> AudioStreamPlayer3DExtended:
	for audio_fx_stream in audio_fx_stream:
		if audio_fx_stream.available:
			return audio_fx_stream
	return null
