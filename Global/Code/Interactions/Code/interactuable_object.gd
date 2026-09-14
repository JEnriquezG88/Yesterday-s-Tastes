extends Node3D
class_name InteractuableObject


var sound_manager : AudioStreamPlayer3D = AudioStreamPlayer3D.new()

func _ready() -> void:
	sound_manager.name = "AudioManager"
	sound_manager.bus = "VFX"
	add_child(sound_manager)

func interact() -> void:
	pass

func charge_completed() -> void:
	pass

func shot_sound(sound: AudioStream) -> void:
	sound_manager.stream = sound
	sound_manager.play()
