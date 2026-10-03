extends Node
class_name TransitionInteraction

@export var new_enter_position_node : Node3D 
@export var new_exit_position_node : Node3D 

func interact(new_position: Node3D, new_camera_view: CameraController.CAMERA_TYPES) -> void:
	print("tin")
	GlobalSignals.transition_interaction.emit(new_position.global_position, new_camera_view)


func _on_area_3d_body_entered(body: Node3D) -> void:
	interact(new_enter_position_node, CameraController.CAMERA_TYPES.horizontal_view)


func _on_exit_body_entered(body: Node3D) -> void:
	interact(new_exit_position_node, CameraController.CAMERA_TYPES.normal_view)
