extends VBoxContainer
class_name OptionsMenuManager

@export var previous_menu : VBoxContainer = null
@onready var buttons_container: ButtonsContainer = $ButtonsContainer

@onready var graphics_button: Button = $ButtonsContainer/GraphicsButton
@onready var audio_button: Button = $ButtonsContainer/AudioButton
@onready var lenguage_button: Button = $ButtonsContainer/LenguageButton
@onready var return_button: Button = $ButtonsContainer/ReturnButton

@onready var graphics_settings: GraphicsMenu = $GraphicsSettings
@onready var audio_settings: AudioMenu = $AudioSettings
@onready var lenguage_settings: LenguageMenu = $LenguageSettings


@onready var options: Label = $HBoxContainer/options
@onready var graphics: Label = $HBoxContainer/graphics
@onready var audio: Label = $HBoxContainer/audio
@onready var lenguage: Label = $HBoxContainer/lenguage


func _ready() -> void:
	visible = false


func start_menu() -> void:
	visible = true
	options.visible = true
	graphics.visible = false
	audio.visible = false
	lenguage.visible = false
	
	_init_button_signals()
	buttons_container.visible = true
	buttons_container.first_element_focus()

func _init_button_signals() -> void:
	graphics_button.button_up.connect(_on_graphics_button_up)
	audio_button.button_up.connect(_on_audio_button_up)
	lenguage_button.button_up.connect(_on_lenguage_button_up)
	return_button.button_up.connect(_on_exit_button_up)

func _finish_button_signals() -> void:
	graphics_button.button_up.disconnect(_on_graphics_button_up)
	audio_button.button_up.disconnect(_on_audio_button_up)
	lenguage_button.button_up.disconnect(_on_lenguage_button_up)
	return_button.button_up.disconnect(_on_exit_button_up)

func _on_graphics_button_up() -> void:
	options.visible = false
	graphics.visible = true
	buttons_container.visible = false
	graphics_settings.start_menu()

func _on_audio_button_up() -> void:
	options.visible = false
	audio.visible = true
	buttons_container.visible = false
	audio_settings.start_menu()

func _on_lenguage_button_up() -> void:
	options.visible = false
	lenguage.visible = true
	buttons_container.visible = false
	lenguage_settings.start_menu()

func _on_exit_button_up() -> void:
	_finish_button_signals()
	visible = false
	if previous_menu:
		previous_menu.start_menu()
