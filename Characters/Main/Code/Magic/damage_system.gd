extends Node
class_name DamageSystem

@onready var character_controller: CharacterController = $"../.."
@onready var movement: Movement = $"../Movement"
@onready var magic_system: MagicSystem = $"../MagicSystem"


func _on_attacks_detector_area_entered(area: Area3D) -> void:
	character_controller.current_state == CharacterController.STATES.DAMAGE
	character_controller.animation_tree.set("parameters/Damages/DamageTypes/transition_request","back_push")
	character_controller.animation_tree.set("parameters/GeneralStates/transition_request","Damage")
	character_controller.rotation.y = area.get_parent_node_3d().get_parent_node_3d().global_rotation.y + PI

func _on_damage_finish() -> void:
	if character_controller.is_on_floor():
		movement.is_dash_cooldown = false
		movement.can_floor_jump = true
		character_controller.animation_tree.set("parameters/Movement/MovementTypes/transition_request","floor_movement")
		if character_controller.current_state != CharacterController.STATES.WAITING:
			character_controller.current_state = CharacterController.STATES.MOVEMENT
	else:
		character_controller.current_state = CharacterController.STATES.JUMP
	magic_system._can_shot_magic_bool = true
	character_controller.animation_tree.set("parameters/GeneralStates/transition_request","Movement")


func _on_attacks_detector_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	if character_controller.current_state == CharacterController.STATES.MAGIC:
		GlobalSignals.camera_zoom.emit(0.0)
		
	if character_controller.current_state == CharacterController.STATES.DASH:
		var to_area := (area.global_position - character_controller.global_position).normalized()
		
		var character_forward := character_controller.global_transform.basis.z.normalized()
		
		var facing := character_forward.dot(to_area)
		
		if facing < -0.5:
			return
	if character_controller.is_on_floor():
		GlobalSignals.shot_dash_particles.emit(character_controller, Vector3.ZERO, character_controller.global_rotation)
	
	character_controller.current_state = CharacterController.STATES.DAMAGE
	character_controller.animation_tree.set("parameters/Damages/DamageTypes/transition_request","back_push")
	character_controller.animation_tree.set("parameters/GeneralStates/transition_request","Damage")
	#character_controller.look_at(area.global_position, Vector3.UP)
	character_controller.rotation.y = area.global_rotation.y + PI
	
