extends Control
class_name CheckPointTransition

@onready var color_rect: ColorRect = $ColorRect

signal transition_finished

func activate_transition(new_position: Vector2) -> void:
	var viewport_size : Vector2 = get_viewport_rect().size
	var mask_position : Vector2 = new_position / viewport_size
	
	var material : ShaderMaterial = color_rect.material as ShaderMaterial
	material.set_shader_parameter("mask_position", mask_position)
	
	var tween : Tween = create_tween()
	
	tween.tween_method(
		func(value: float):
			material.set_shader_parameter("mask_scale", Vector2(value, value)),
			3.5,
			0.0,
			0.2
	)
	tween.tween_callback(func():
		transition_finished.emit()
	)
	await get_tree().process_frame
	tween.tween_method(
		func(value: float):
			material.set_shader_parameter("mask_scale", Vector2(value, value)),
			0.0,
			3.5,
			0.2
	)
