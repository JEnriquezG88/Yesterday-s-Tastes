extends Node3D
class_name JumpMagicFXManager

var available : bool = true

var finished_particles : int = 0
var total_particles : int = 4

@onready var particles : Array[GPUParticles3D] = [
	$"01",
	$"02",
	$"03",
	$"04"
]

func _ready() -> void:
	for particle in particles:
		particle.finished.connect(_on_particle_finished)
		#particle.process_material = particle.process_material.duplicate()

func shot_particles() -> void:
	available = false
	for particle in particles:
		particle.emitting = true

func _on_particle_finished() -> void:
	finished_particles = finished_particles + 1
	if finished_particles == particles.size():
		finished_particles = 0
		available = true
