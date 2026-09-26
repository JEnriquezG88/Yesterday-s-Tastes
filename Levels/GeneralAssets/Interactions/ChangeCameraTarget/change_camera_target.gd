extends Area3D
class_name ChangeCameraTarget

@export var new_position_node : Node3D
func _ready() -> void:
	if new_position_node:
		body_entered.connect(_on_body_entered)

func _on_body_entered(_body: Node3D) -> void:
	body_entered.disconnect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	GlobalSignals.change_camera_target.emit(new_position_node)

func _on_body_exited(_body: Node3D) -> void:
	body_exited.disconnect(_on_body_exited)
	body_entered.connect(_on_body_entered)
	GlobalSignals.return_to_camera_original_target.emit()
