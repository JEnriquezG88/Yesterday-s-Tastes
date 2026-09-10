extends AudioStreamPlayer3D
class_name AudioStreamPlayer3DExtended

var available : bool = true

func _ready() -> void:
	finished.connect(_on_audio_finished)
 
func shot_sound(new_stream: AudioStream) -> void:
	available = false
	stream = new_stream
	play()

func _on_audio_finished() -> void:
	await get_tree().process_frame
	available = true
