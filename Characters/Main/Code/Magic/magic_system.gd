extends Node
class_name MagicSystem

enum  MAGIC_TYPES {
	NONE,
	ICE,
	BROKE,
	FIRE
}

var current_magic_type : MAGIC_TYPES = MAGIC_TYPES.NONE

@onready var character_controller: CharacterController = $"../.."
@onready var input_and_buffer: InputAndBuffer = $"../InputAndBuffer"

@onready var hit_particles: HitParticles = $"../../Systems/LocalParticles/HitParticles"
@onready var snow_particles: GPUParticles3D = $"../../Systems/LocalParticles/SnowParticles"
@onready var fire_particles: GPUParticles3D = $"../../Systems/LocalParticles/FireParticles"

@onready var audio_manager: AudioManager = $"../../Systems/AudioManager"


func _can_shot_magic() -> bool:
	if character_controller.current_state == CharacterController.STATES.JUMP: return false
	if character_controller.current_state == CharacterController.STATES.DASH: return false
	if character_controller.current_state == CharacterController.STATES.MAGIC: return false
	return true

func shot_magic_fx() -> void:
	hit_particles.shot_particles()
	audio_manager.shot_bells_effect()
	audio_manager.shot_shot_magic_fx()
	#GlobalSignals.shot_jump_magic_particles.emit(character_controller.global_position + (Vector3(0.0, 0.789, 0.987) * character_controller.basis))
	GlobalSignals.shot_jump_magic_particles.emit(hit_particles.global_position)
	GlobalSignals.camera_shake.emit(0.3, 0.3)
	GlobalSignals.shot_magic.emit(current_magic_type)
	match current_magic_type:
		MAGIC_TYPES.ICE:
			snow_particles.emitting = true
		MAGIC_TYPES.FIRE:
			fire_particles.emitting = true

func try_shot_magic(magic_type: MAGIC_TYPES) -> bool:
	if not _can_shot_magic(): return false
	
	character_controller.current_state = CharacterController.STATES.MAGIC
	character_controller.velocity = Vector3.ZERO
	match magic_type:
		MAGIC_TYPES.ICE:
			current_magic_type = MAGIC_TYPES.ICE
		MAGIC_TYPES.FIRE:
			current_magic_type = MAGIC_TYPES.FIRE
		MAGIC_TYPES.BROKE:
			current_magic_type = MAGIC_TYPES.BROKE
	character_controller.animation_tree.set("parameters/GeneralStates/transition_request", "Magic")
	GlobalSignals.shot_magic.emit(current_magic_type)
	GlobalSignals.camera_zoom.emit(-3.0)
	audio_manager.shot_charge_magic_fx()
	return true

func finish_magic_animation() -> void:
	current_magic_type = MAGIC_TYPES.NONE
	character_controller.current_state = CharacterController.STATES.MOVEMENT
	character_controller.animation_tree.set("parameters/GeneralStates/transition_request", "Movement")
	GlobalSignals.camera_zoom.emit(0.0)
	if input_and_buffer.current_pending_action != InputAndBuffer.ACTIONS.NONE:
		input_and_buffer.process_pending_actions(input_and_buffer.current_pending_action)
