extends Node
class_name GameSettingsScript

const SETTINGS_PATH : String = "user://game_settings/settings.cfg"

var config : ConfigFile = ConfigFile.new()

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute("user://game_settings")
	load_settings()

#region SetSettings

func set_resolution(new_resolution: Vector2i) -> void:
	DisplayServer.window_set_size(new_resolution)
	var viewport : = get_viewport()
	var current_resolution := DisplayServer.window_get_size()
	
	var scale_x := float(new_resolution.x) / float(current_resolution.x)
	var scale_y := float(new_resolution.x) / float(current_resolution.y)
	
	viewport.scaling_3d_scale = min(scale_x, scale_y)
	config.set_value("display", "resolution", viewport.scaling_3d_scale)
	save_settings()

func set_fullscreen(fullscreen: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
	config.set_value("display", "fullscreen", fullscreen)
	save_settings()

signal set_shadows_signal(shadows: bool)
signal set_shadows_quality_signal(shadows_quality: int)
signal set_ao_signal(shadows: bool)

func set_shadows(shadows: bool) -> void:
	config.set_value("display", "shadows", shadows)
	set_shadows_signal.emit(shadows)
	save_settings()

func set_shadow_quality(shadow_size: int) -> void:
	RenderingServer.directional_shadow_atlas_set_size(shadow_size, true)
	_set_shadow_filter(shadow_size)
	config.set_value("display", "shadows_size", shadow_size)
	save_settings()

func _set_shadow_filter(shadow_size: int) -> void:
	match shadow_size:
		1024:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_HARD)
		2048:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
		4096:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
		8192:
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
	set_shadows_quality_signal.emit(shadow_size)

func set_ao(ao: bool) -> void: # ao = Ambient Occlusion
	config.set_value("display", "ao", ao)
	set_ao_signal.emit(ao)
	save_settings()

func set_max_fps(fps: int) -> void:
	Engine.max_fps = fps
	config.set_value("display", "max_fps", fps)
	save_settings()

func set_bus_volume(bus_name: StringName, volume: float) -> void:
	volume = clampf(volume, 0.0, 100.0)
	
	var bus_index : int = AudioServer.get_bus_index(bus_name)
	
	if bus_index == -1: return
	
	var db: = linear_to_db(volume / 100.0)
	
	AudioServer.set_bus_volume_db(bus_index, db)
	
	config.set_value("audio", bus_name, db)
	save_settings()

func set_lenguage(lenguage: String) -> void:
	TranslationServer.set_locale(lenguage)
	config.set_value("lenguage", "locale", lenguage)
	save_settings()

#endregion

func save_settings() -> void:
	config.save(SETTINGS_PATH)

func load_settings() -> void:
	if config.load(SETTINGS_PATH) != OK: 
		save_settings()
	
	#region Graphics
	var viewport : = get_viewport()
	viewport.scaling_3d_scale = config.get_value("display", "resolution", 1.0)
	var current_resolution := DisplayServer.window_get_size()
	DisplayServer.window_set_size(current_resolution * viewport.scaling_3d_scale)
	var shadow_size : int = config.get_value("display", "shadows_size", 8192)
	RenderingServer.directional_shadow_atlas_set_size(shadow_size, true)
	_set_shadow_filter(shadow_size)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if config.get_value("display", "fullscreen", false) else DisplayServer.WINDOW_MODE_WINDOWED)
	Engine.max_fps = config.get_value("display", "max_fps", 60)
	#endregion
	#region Audio
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), config.get_value("audio", "Master", 0.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("VFX"), config.get_value("audio", "VFX", 0.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voices"), config.get_value("audio", "Voices", 0.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), config.get_value("audio", "Music", 0.0))
	#endregion
	#region Lenguage
	var default_lenguage : String = OS.get_locale_language()
	if default_lenguage != "es" and default_lenguage != "en":
		default_lenguage = "en"
	TranslationServer.set_locale(config.get_value("lenguage", "locale", default_lenguage))
	#endregion
