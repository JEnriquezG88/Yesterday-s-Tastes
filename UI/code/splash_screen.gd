extends Control

@onready var fade_manager: FadeManager = $FadeManager
@onready var jmdev: TextureRect = $JMDEV
@onready var godot_logo_container: ColorRect = $GodotLogoContainer

func _ready() -> void:
	fade_manager.visible = true
	await fade_manager._fade_in()
	await get_tree().create_timer(1.0).timeout
	await fade_manager._fade_out()
	jmdev.visible = false
	godot_logo_container.visible = true
	await fade_manager._fade_in()
	await get_tree().create_timer(1.0).timeout
	await fade_manager._fade_out()
	get_tree().change_scene_to_file("uid://dr3x2e25y5jxk")
