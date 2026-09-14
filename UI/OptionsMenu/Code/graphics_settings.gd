extends VBoxContainer
class_name GraphicsMenu

@export var previous_menu : VBoxContainer = null

@onready var resolutions: OptionButton = $ResolutionContainer/Resolutions
@onready var fullscreen_checkbox: CheckBox = $FullscreenContainer/FullscreenCheckbox
@onready var fps_options: OptionButton = $FpsContainer/FpsOptions
@onready var return_button: Button = $ReturnButton

@onready var shadows_checkbox: CheckBox = $ShadowsOption/ShadowsCheckbox
@onready var ao_checkbox: CheckBox = $AOOption/AOCheckbox

@onready var shadows_quality: HBoxContainer = $ShadowsQuality
@onready var shadow_qualities: OptionButton = $ShadowsQuality/ShadowQualities

func _ready() -> void:
	visible = false


func start_menu() -> void:
	visible = true
	resolutions.grab_focus()
	_init_button_signals()
	_load_values()

func _init_button_signals() -> void:
	resolutions.item_selected.connect(_on_resolution_selected)
	fullscreen_checkbox.toggled.connect(_on_fullscreen_toggled)
	shadows_checkbox.toggled.connect(_on_shadows_toggled)
	shadow_qualities.item_selected.connect(_on_shadows_quality_selected)
	ao_checkbox.toggled.connect(_on_ao_toggled)
	fps_options.item_selected.connect(_on_fps_selected)
	return_button.button_up.connect(_on_exit_button_up)

func _finish_button_signals() -> void:
	resolutions.item_selected.disconnect(_on_resolution_selected)
	fullscreen_checkbox.toggled.disconnect(_on_fullscreen_toggled)
	shadows_checkbox.toggled.disconnect(_on_shadows_toggled)
	ao_checkbox.toggled.disconnect(_on_ao_toggled)
	fps_options.item_selected.disconnect(_on_fps_selected)
	return_button.button_up.disconnect(_on_exit_button_up)

func _on_resolution_selected(index: int) -> void:
	match index:
		0:
			GameSettings.set_resolution(Vector2i(1280, 720))
		1:
			GameSettings.set_resolution(Vector2i(1920, 1080))
		2:
			GameSettings.set_resolution(Vector2i(2560, 1440))
		3:
			GameSettings.set_resolution(Vector2i(3840, 2160))

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	GameSettings.set_fullscreen(toggled_on)

func _on_shadows_toggled(toggled_on: bool) -> void:
	GameSettings.set_shadows(toggled_on)
	if toggled_on:
		shadows_quality.visible = true
	else:
		shadows_quality.visible = false

func _on_shadows_quality_selected(index: int) -> void:
	match index:
		0:
			GameSettings.set_shadow_quality(1024)
		1:
			GameSettings.set_shadow_quality(2048)
		2:
			GameSettings.set_shadow_quality(4096)
		3:
			GameSettings.set_shadow_quality(8192)

func _on_ao_toggled(toggled_on: bool) -> void:
	GameSettings.set_ao(toggled_on)

func _on_fps_selected(index: int) -> void:
	match index:
		0:
			GameSettings.set_max_fps(30)
		1:
			GameSettings.set_max_fps(60)
		2:
			GameSettings.set_max_fps(120)
		3:
			GameSettings.set_max_fps(0)

func _on_exit_button_up() -> void:
	_finish_button_signals()
	visible = false
	if previous_menu:
		previous_menu.start_menu()

func _load_values() -> void:
	print(GameSettings.config.get_value("display", "resolution"))
	match GameSettings.config.get_value("display", "resolution"):
		Vector2i(1280, 720):
			print(0)
			resolutions.selected = 0
		Vector2i(1920, 1080):
			print(1)
			resolutions.selected = 1
		Vector2i(2560, 1440):
			print(2)
			resolutions.selected = 2
		Vector2i(3840, 2160):
			print(3)
			resolutions.selected = 3
	
	match GameSettings.config.get_value("display", "max_fps"):
		30:
			fps_options.selected = 0
		60:
			fps_options.selected = 1
		120:
			fps_options.selected = 2
		0:
			fps_options.selected = 3
	
	fullscreen_checkbox.button_pressed = GameSettings.config.get_value("display", "fullscreen", false)
	shadows_checkbox.button_pressed = GameSettings.config.get_value("display", "shadows", false)
	if shadows_checkbox.button_pressed:
		shadows_quality.visible = true
		
		match GameSettings.config.get_value("display", "shadows_size", 8192):
			1024:
				shadow_qualities.selected = 0
			2048:
				shadow_qualities.selected = 1
			4096:
				shadow_qualities.selected = 2
			8192:
				shadow_qualities.selected = 3
		
	else:
		shadows_quality.visible = false
	ao_checkbox.button_pressed = GameSettings.config.get_value("display", "ao", false)
