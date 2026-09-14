extends Control
class_name PauseMenuManager

@onready var continue_button: Button = $PauseMenuContainer/PauseMenu/ContinueButton
@onready var options_button: Button = $PauseMenuContainer/PauseMenu/OptionsButton
@onready var return_button: Button = $PauseMenuContainer/PauseMenu/ReturnButton


@onready var pause_menu: ButtonsContainer = $PauseMenuContainer/PauseMenu
@onready var pause_menu_container: VBoxContainer = $PauseMenuContainer
@onready var options_menu: OptionsMenuManager = $OptionsMenu

@export var fade_manager : FadeManager 

func _ready() -> void:
	visible = false
	#start_menu()

func start_menu() -> void:
	get_tree().paused = true
	visible = true
	pause_menu_container.visible = true
	options_menu.visible = false
	_init_button_signals()
	pause_menu.first_element_focus()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("pause"):
		if get_tree().paused:
			_on_continue_button_up()
		else:
			start_menu()

func _init_button_signals() -> void:
	continue_button.button_up.connect(_on_continue_button_up)
	options_button.button_up.connect(_on_options_button_up)
	return_button.button_up.connect(_on_exit_button_up)

func _finish_button_signals() -> void:
	continue_button.button_up.disconnect(_on_continue_button_up)
	options_button.button_up.disconnect(_on_options_button_up)
	return_button.button_up.disconnect(_on_exit_button_up)

func _on_exit_button_up() -> void:
	_finish_button_signals()
	get_tree().paused = false
	if fade_manager:
		await fade_manager._fade_out()
	get_tree().change_scene_to_file("uid://dr3x2e25y5jxk")

func _on_continue_button_up() -> void:
	visible = false
	get_tree().paused = false
	pause_menu.change_first_element(continue_button)

func _on_options_button_up() -> void:
	pause_menu_container.visible = false
	options_menu.start_menu()
	pause_menu.change_first_element(options_button)
