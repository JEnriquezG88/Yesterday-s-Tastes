extends Node3D
class_name CameraController

@export var target : Node3D
var follow : bool = true

@onready var follow_node: Node3D = $Follow
@onready var horizontal: Node3D = $Horizontal
@onready var camera_3d: Camera3D = $Horizontal/Vertical/Camera3D



func _process(delta: float) -> void:
	if follow: _follow_target(delta)

func _follow_target(delta: float) -> void:
	var direction : Vector2 = Input.get_vector("left", "right", "backward", "forward")
	follow_node.global_position = target.global_position + target.basis.z * (0.0 * direction.length())
	horizontal.global_position.x = lerp(horizontal.global_position.x, follow_node.global_position.x, delta * 5)
	horizontal.global_position.z = lerp(horizontal.global_position.z, follow_node.global_position.z, delta * 5)
	horizontal.global_position.y = lerp(horizontal.global_position.y, follow_node.global_position.y, delta * 2)
