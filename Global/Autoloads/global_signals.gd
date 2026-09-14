extends Node
class_name GlobalSignalsCode

signal shot_jump_magic_particles(position: Vector3)
signal shot_ground_impact_particles(position: Vector3)
signal shot_dash_particles(follow_character: Node3D, follow_character_offset: Vector3, rotation: Vector3)


signal camera_shake(intensity: float, duration: float)
signal camera_zoom(amount: float)
signal force_camera_position()

signal shot_magic(magic_type: MagicSystem.MAGIC_TYPES)
