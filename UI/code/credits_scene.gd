extends Node3D
class_name CreditsScene
@onready var fade_manager: FadeManager = $CanvasLayer/FadeManager



func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("ui_cancel"):
		set_process_input(false)
		return_to_main_menu()

func return_to_main_menu() -> void:
	await fade_manager._fade_out()
	get_tree().change_scene_to_file("uid://dr3x2e25y5jxk")
