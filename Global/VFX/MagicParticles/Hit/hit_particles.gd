extends Node3D
class_name HitParticles

@onready var particles : Array[GPUParticles3D] = [
	$Hit1, $Hit2, $Hit3
]

func shot_particles() -> void:
	for particle in particles:
		particle.emitting = true
