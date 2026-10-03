extends Node
class_name GlobalSignalsCode

signal shot_jump_magic_particles(position: Vector3)
signal shot_ground_impact_particles(position: Vector3)
signal shot_dash_particles(follow_character: Node3D, follow_character_offset: Vector3, rotation: Vector3)


signal camera_shake(intensity: float, duration: float)
signal camera_zoom(amount: float)
signal force_camera_position()
signal change_camera_target(new_target: Node3D)
signal return_to_camera_original_target()

signal shot_magic(magic_type: MagicSystem.MAGIC_TYPES)
signal main_character_wait
signal main_character_resume
signal transition_interaction(new_position: Vector3, camera_type: CameraController.CAMERA_TYPES)
signal change_camera_view(new_camera_view : CameraController.CAMERA_TYPES)

signal first_scenario_loaded
signal is_stamp_sound(value: bool)
signal load_lobby


signal stop_current_song
signal play_next_song
