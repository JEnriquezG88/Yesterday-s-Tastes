extends GPUParticles3D
class_name ParticlesBase

var is_available : bool = true

var follow_node : Node3D
var follow_node_offset : Vector3 = Vector3.ZERO

func _ready() -> void:
	finished.connect(_on_particles_finished)

func _physics_process(_delta: float) -> void:
	if follow_node:
		global_position = follow_node.position + follow_node_offset

func set_follow_node(node: Node3D = null, new_offset: Vector3 = Vector3.ZERO) -> void:
	if follow_node != node:
		set_physics_process(true)
		follow_node = node
		follow_node_offset = new_offset
	else:
		set_physics_process(false)

func start_particles(new_process_material: ParticleProcessMaterial) -> void:
	is_available = false
	self.process_material = new_process_material.duplicate()
	emitting = true

func _on_particles_finished() -> void:
	is_available = true
	self.process_material = null
	set_follow_node()
