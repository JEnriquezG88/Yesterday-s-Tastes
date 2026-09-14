extends Node
class_name CheckPointsSystem


@onready var character_controller: CharacterController = $"../.."
@onready var audio_manager: AudioManager = $"../../Systems/AudioManager"

@onready var check_point_detector: Area3D = $"../../Systems/Areas/CheckPointDetector"
@onready var reset_zone_detector: Area3D = $"../../Systems/Areas/ResetZoneDetector"

@onready var check_point_transition: CheckPointTransition = $"../../UI/CheckPointTransition"


var last_check_point_position : Vector3 = Vector3.ZERO
var last_check_point_rotation : Vector3 = Vector3.ZERO

func _ready() -> void:
	check_point_detector.area_shape_entered.connect(_on_check_point_detector_area_shape_entered)
	reset_zone_detector.area_shape_entered.connect(_on_reset_zone_detector_area_shape_entered)

func change_last_check_point_position(new_position: Vector3, new_rotation: Vector3) -> void:
	if new_position != last_check_point_position:
		last_check_point_position = new_position
	if new_rotation != last_check_point_rotation:
		last_check_point_rotation = new_rotation

func activate_check_point() -> void:
	var camera := get_viewport().get_camera_3d()
	var screen_position := camera.unproject_position(character_controller.global_position)
	check_point_transition.activate_transition(screen_position)
	await check_point_transition.transition_finished
	
	character_controller.global_position = last_check_point_position
	character_controller.velocity = Vector3.ZERO
	audio_manager.shot_bells_effect()
	GlobalSignals.force_camera_position.emit()
	GlobalSignals.shot_jump_magic_particles.emit(character_controller.global_position)


func _on_check_point_detector_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	change_last_check_point_position(area.global_position, character_controller.global_rotation)

func _on_reset_zone_detector_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	activate_check_point()
