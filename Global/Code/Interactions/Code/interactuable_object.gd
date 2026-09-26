extends Node3D
class_name InteractuableObject


var sound_manager : AudioStreamPlayer3D = AudioStreamPlayer3D.new()

var completed : bool = false

func _ready() -> void:
	sound_manager.name = "AudioManager"
	sound_manager.bus = "VFX"
	add_child(sound_manager)

func interact() -> void:
	completed = true

func charge_completed() -> void:
	completed = true

func shot_sound(sound: AudioStream) -> void:
	sound_manager.stream = sound
	sound_manager.play()
