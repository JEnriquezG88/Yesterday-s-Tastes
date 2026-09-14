extends Node3D
class_name CameraController

@export var target : Node3D
var follow : bool = true

@onready var follow_node: Node3D = $Follow
@onready var horizontal: Node3D = $Horizontal
@onready var camera_3d: Camera3D = $Horizontal/Vertical/Camera3D

@onready var animation_tree: AnimationTree = $Horizontal/Vertical/Camera3D/AnimationTree

var original_camera_distance : float = 6.5
var zoom_camera_dinstance : float = 0.0

func _process(delta: float) -> void:
	if follow: _follow_target(delta)
	if process_zoom: _process_new_zoom(delta)

func _follow_target(delta: float) -> void:
	var direction : Vector2 = Input.get_vector("left", "right", "backward", "forward")
	#follow_node.global_position = target.global_position + target.basis.z * Vector3(0.0, 0.0, (1.0 * direction.length()))
	#follow_node.global_position = target.global_position + target.basis.z * (absf(direction.y) * 3.0) if direction.y < 0 else target.global_position
	follow_node.global_position = target.global_position
	horizontal.global_position.x = lerp(horizontal.global_position.x, follow_node.global_position.x, delta * 5)
	horizontal.global_position.z = lerp(horizontal.global_position.z, follow_node.global_position.z, delta * 5)
	horizontal.global_position.y = lerp(horizontal.global_position.y, follow_node.global_position.y, delta * 2)

var process_zoom : bool = false

func _process_new_zoom(delta: float) -> void:
	camera_3d.position.z = lerpf(camera_3d.position.z, zoom_camera_dinstance, delta * 2)
	if camera_3d.position.z == zoom_camera_dinstance:
		process_zoom = false

func zoom(amount: float) -> void:
	zoom_camera_dinstance = original_camera_distance + amount
	process_zoom = true

func _ready() -> void:
	shake_duration_timer.one_shot = true
	shake_duration_timer.timeout.connect(_on_shake_duration_timer_time_out)
	add_child(shake_duration_timer)
	GlobalSignals.camera_shake.connect(shake)
	GlobalSignals.camera_zoom.connect(zoom)
	GlobalSignals.force_camera_position.connect(_force_camera_position)

func _force_camera_position() -> void:
	follow_node.global_position = target.global_position
	horizontal.global_position = follow_node.global_position

var shake_duration_timer : Timer = Timer.new()

func shake(intensity: float, duration: float) -> void:
	animation_tree.set("parameters/ShakeBlend/blend_amount", intensity * 0.5)
	if not shake_duration_timer.is_stopped():
		shake_duration_timer.stop()
	shake_duration_timer.wait_time = duration
	shake_duration_timer.start()
	_trigger_vibration(intensity * 1.5)

func _trigger_vibration(intensity: float) -> void:
	var joypads := Input.get_connected_joypads()
	if joypads.is_empty():
		return
	
	for joypad in joypads:
		var device := joypad
		var weak := 0.2 * intensity * 1.5
		var strong := 1.0 * intensity * 1.5
		var duration := 0.15 + 0.25 * intensity
		Input.start_joy_vibration(device, weak, strong, duration)

func _on_shake_duration_timer_time_out() -> void:
	animation_tree.set("parameters/ShakeBlend/blend_amount", 0.0)
