extends Node3D
class_name SmokeParticlesManager

const DASH_PROCESS_MATERIAL = preload("uid://cqnf6a8q2m85v")
const GROUND_IMPACT_PROCESS_MATERIAL = preload("uid://chgcqblvogktm")
const JUMP_PROCESS_MATERIAL = preload("uid://b8xp4aiyc7les")

var smoke_particles : Array[ParticlesBase] = []
const SMOKE_PARTICLES_BASE = preload("uid://b06vixdeb65mj")

func _ready() -> void:
	print("ready")
	for i in 5:
		var smoke_particle : ParticlesBase = SMOKE_PARTICLES_BASE.instantiate()
		add_child(smoke_particle)
		smoke_particles.append(smoke_particle)
	GlobalSignals.shot_ground_impact_particles.connect(shot_ground_impact_particles)
	GlobalSignals.shot_dash_particles.connect(shot_dash_particles)

func shot_dash_particles(follow_character: Node3D, follow_character_offset: Vector3, rotation: Vector3) -> void:
	var particle : ParticlesBase = _get_available_particles()
	if not particle: return
	
	particle.rotation = rotation
	particle.set_follow_node(follow_character, follow_character_offset)
	particle.explosiveness = 0.0
	particle.start_particles(DASH_PROCESS_MATERIAL)

func shot_jump_particle(particle_position: Vector3, particle_rotation: Vector3) -> void:
	print("hola")
	var particle : ParticlesBase = _get_available_particles()
	if not particle: return
	
	particle.global_position = particle_position
	particle.rotation = particle_rotation
	particle.explosiveness = 0.8
	particle.start_particles(JUMP_PROCESS_MATERIAL)

func shot_ground_impact_particles(particle_position: Vector3) -> void:
	var particle : ParticlesBase = _get_available_particles()
	if not particle: return
	
	particle.global_position = particle_position
	particle.rotation = Vector3.ZERO
	particle.explosiveness = 1.0
	particle.start_particles(GROUND_IMPACT_PROCESS_MATERIAL)

func _get_available_particles() -> ParticlesBase:
	for particle in smoke_particles:
		if particle.is_available:
			return particle
	return null
