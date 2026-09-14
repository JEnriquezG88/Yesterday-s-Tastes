extends Node
class_name Movement


@onready var character_controller: CharacterController = $"../.."
@onready var input_and_buffer: InputAndBuffer = $"../InputAndBuffer"

var coyote_time_timer : Timer = Timer.new()
var dash_cooldown : Timer = Timer.new()

@onready var audio_manager: AudioManager = $"../../Systems/AudioManager"

func _process(delta: float) -> void:
	movement(delta)
	if character_controller.current_state == CharacterController.STATES.JUMP:
		_process_jump_logic(delta)
	process_root_motion(delta)
	character_controller.move_and_slide()

func _ready() -> void:
	coyote_time_timer.one_shot = true
	coyote_time_timer.wait_time = 0.1
	coyote_time_timer.name = "CoyoteTimeTimer"
	coyote_time_timer.timeout.connect(_on_coyote_time_timer)
	add_child(coyote_time_timer)
	
	dash_cooldown.one_shot = true
	dash_cooldown.wait_time = 0.02
	dash_cooldown.name = "DashCooldownTimer"
	dash_cooldown.timeout.connect(_on_dash_cooldown_timeout)
	add_child(dash_cooldown)

var can_process_root_motion : bool = true

func process_root_motion(delta: float) -> void:
	if character_controller.current_state != CharacterController.STATES.MOVEMENT:
		if character_controller.current_state != CharacterController.STATES.MAGIC: 
			if character_controller.current_state != CharacterController.STATES.DASH: 
				return
	if not can_process_root_motion: return
	
	var root_motion : Vector3 = character_controller.animation_tree.get_root_motion_position()
	var velocity : Vector3 = character_controller.global_basis * (root_motion / delta)
	
	character_controller.velocity.x = velocity.x
	character_controller.velocity.z = velocity.z

func _physics_process(delta: float) -> void:
	pass

var direction : Vector2
var target_angle : float
func movement(delta) -> void:
	direction = Input.get_vector("left", "right", "backward", "forward")
	if character_controller.current_state == CharacterController.STATES.DASH: return
	
	if  character_controller.current_state != CharacterController.STATES.JUMP and not character_controller.is_on_floor():
		if can_floor_jump:
			if not coyote_time_timer.is_stopped(): coyote_time_timer.stop()
			coyote_time_timer.start()
		character_controller.current_state = CharacterController.STATES.JUMP
		character_controller.animation_tree.set("parameters/Movement/MovementTypes/transition_request", "jump")

	character_controller.animation_tree.set("parameters/Movement/Movement/conditions/idle", not direction)
	character_controller.animation_tree.set("parameters/Movement/Movement/conditions/walk", direction)
	
	var current_camera : Camera3D = get_viewport().get_camera_3d()
	
	var forward : Vector3 = -current_camera.global_basis.z
	var right :Vector3 = current_camera.global_basis.x
	forward.y = 0.0
	right.y = 0.0
	forward = forward.normalized()
	right = right.normalized()
	
	var movement_direction : Vector3 = (right * direction.x + forward * direction.y).normalized()
	
	var direction_lenght_squared : float = direction.length_squared()
	if direction_lenght_squared > 0.0:
		if direction_lenght_squared > 0.4:
			character_controller.animation_tree.set("parameters/Movement/Movement/walk_and_run/blend_position", 1.0)
		else:
			character_controller.animation_tree.set("parameters/Movement/Movement/walk_and_run/blend_position", 0.0)
		
		target_angle = atan2(movement_direction.x, movement_direction.z)
		
		character_controller.rotation.y = lerp_angle(character_controller.rotation.y, target_angle, 20.0 * delta)

#region Jump
var can_air_jump : bool = true
var can_floor_jump : bool = true

func _can_jump() -> bool:
	if character_controller.current_state == CharacterController.STATES.JUMP: return true
	if character_controller.current_state != CharacterController.STATES.MOVEMENT: return false
	return true

func try_jump() -> bool:
	#if character_controller.current_state != CharacterController.STATES.MOVEMENT: return false
	#if not character_controller.is_on_floor():
	if not _can_jump(): return false
	
	if not can_floor_jump:
		if character_controller.velocity.y > 0.0:
			return false
		elif not can_air_jump:
			return false
		else:
			can_air_jump = false
			audio_manager.shot_bells_effect()
			GlobalSignals.shot_jump_magic_particles.emit(character_controller.global_position)
	can_floor_jump = false
	character_controller.velocity.y = 15
	audio_manager.shot_wosh_sound()
	return true

func _process_jump_logic(delta) -> void:
	var normalice_velocity : float = character_controller.velocity.y
	
	if input_and_buffer.current_pending_action != InputAndBuffer.ACTIONS.NONE:
		if can_air_jump and normalice_velocity < 0.0:
			input_and_buffer.process_pending_actions(input_and_buffer.current_pending_action)
	
	normalice_velocity = normalice_velocity / 10
	character_controller.animation_tree.set("parameters/Movement/JumpAnimations/blend_position", normalice_velocity)
	
	if character_controller.is_on_floor():
		_finish_jump()
	else:
		#var velocity : Vector3 = character_controller.global_basis * (Vector3(0.0, 0.0, 0.077634) / delta) * direction.length()
		var velocity : Vector3 = character_controller.global_basis * (Vector3(0.0, 0.0, 4.6)) * direction.length()
		if character_controller.velocity.y <= -23:
			strong_fall = true
		character_controller.velocity.z = velocity.z
		character_controller.velocity.x = velocity.x

var strong_fall : bool = false

func _finish_jump() -> void:
	if strong_fall:
		strong_fall = false
		GlobalSignals.camera_shake.emit(0.1, 0.1)
	audio_manager.shot_floor_impact(0.0)
	GlobalSignals.shot_ground_impact_particles.emit(character_controller.global_position)
	if not can_air_dash: can_air_dash = true
	can_air_jump = true
	can_floor_jump = true
	if not coyote_time_timer.is_stopped(): coyote_time_timer.stop()
	character_controller.current_state = CharacterController.STATES.MOVEMENT
	character_controller.animation_tree.set("parameters/Movement/MovementTypes/transition_request", "floor_movement")
	if input_and_buffer.current_pending_action != InputAndBuffer.ACTIONS.NONE:
		input_and_buffer.process_pending_actions(input_and_buffer.current_pending_action)

func _on_coyote_time_timer() -> void:
	if not character_controller.is_on_floor():
		can_floor_jump = false


#endregion

#region Dash

func _can_dash() -> bool:
	if is_dash_cooldown: return false
	if character_controller.current_state == CharacterController.STATES.JUMP: return true
	if character_controller.current_state != CharacterController.STATES.MOVEMENT: return false
	return true

var can_air_dash : bool = true

func try_dash() -> bool:
	if not _can_dash(): return false
	
	if not character_controller.is_on_floor():
		if not can_air_dash: return false
	else:
		GlobalSignals.shot_dash_particles.emit(character_controller, Vector3.ZERO, character_controller.global_rotation)
	is_dash_cooldown = true
	can_air_dash = false
	if direction.length_squared() > 0:
		character_controller.rotation.y = target_angle
	character_controller.current_state = CharacterController.STATES.DASH
	character_controller.velocity.y = 0.0
	character_controller.animation_tree.set("parameters/Movement/MovementTypes/transition_request", "dash")
	
	audio_manager.shot_bells_effect()
	audio_manager.shot_wosh_sound()
	GlobalSignals.shot_jump_magic_particles.emit(character_controller.global_position)
	
	return true

func _finish_dash() -> void:
	dash_cooldown.start()
	if character_controller.is_on_floor():
		can_air_dash = true
	character_controller.current_state = CharacterController.STATES.MOVEMENT
	character_controller.animation_tree.set("parameters/Movement/MovementTypes/transition_request", "floor_movement")
	if input_and_buffer.current_pending_action != InputAndBuffer.ACTIONS.NONE:
		input_and_buffer.process_pending_actions(input_and_buffer.current_pending_action)

var is_dash_cooldown : bool = false

func _on_dash_cooldown_timeout() -> void:
	is_dash_cooldown = false

#endregion
