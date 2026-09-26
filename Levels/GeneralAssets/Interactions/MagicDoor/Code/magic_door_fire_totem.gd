extends InteractuableObject
class_name FireTotem

signal fire_door_finished

@onready var fire_particles: GPUParticles3D = $FireParticles
@onready var fire_sfx: AudioStreamPlayer3D = $FireSFX


func interact() -> void:
	super.interact()
	GlobalSignals.main_character_wait.emit()
	fire_door_finished.emit()
	fire_particles.emitting = true
	fire_sfx.play()

func charge_completed() -> void:
	super.charge_completed()
	#fire_door_finished.emit()
	fire_particles.emitting = true
	fire_sfx.play()
