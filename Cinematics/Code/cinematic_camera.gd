extends Camera3D
class_name CinematicCamera

@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	GlobalSignals.camera_shake.connect(shake)

var shake_duration_timer : Timer = Timer.new()

func shake(intensity: float, duration: float) -> void:
	shake_duration_timer.one_shot = true
	shake_duration_timer.timeout.connect(_on_shake_duration_timer_time_out)
	add_child(shake_duration_timer)
	animation_tree.set("parameters/ShakeBlend/blend_amount", intensity * 0.1)
	if not shake_duration_timer.is_stopped():
		shake_duration_timer.stop()
	shake_duration_timer.wait_time = duration
	shake_duration_timer.start()
	#_trigger_vibration(intensity * 0.3)
	_trigger_vibration(intensity)

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
