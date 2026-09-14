extends Node3D
class_name LightsAndEnviromentManager

@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var directional_light_3d: DirectionalLight3D = $DirectionalLight3D


func _ready() -> void:
	GameSettings.set_shadows_signal.connect(_on_shadow_change)
	GameSettings.set_ao_signal.connect(_on_ao_change)
	GameSettings.set_shadows_quality_signal.connect(_on_set_shadows_quality)
	
	_on_shadow_change(GameSettings.config.get_value("display", "shadows", true))
	_on_ao_change(GameSettings.config.get_value("display", "ao", true))
	_on_set_shadows_quality(GameSettings.config.get_value("display", "shadows_size", 8192))

func _on_ao_change(ao: bool) -> void:
	world_environment.environment.ssao_enabled = ao

func _on_shadow_change(shadows: bool) -> void:
	directional_light_3d.shadow_enabled = shadows

func _on_set_shadows_quality(shadow_size: int) -> void:
	match shadow_size:
		1024:
			directional_light_3d.shadow_blur = 1.0
		2048:
			directional_light_3d.shadow_blur = 0.775
		4096:
			directional_light_3d.shadow_blur = 0.325
		8192:
			directional_light_3d.shadow_blur = 0.1
