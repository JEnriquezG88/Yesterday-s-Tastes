extends Control
class_name Tutorials

enum TUTORIALS {
	MOVEMENT,
	JUMP,
	DASH,
	ATTACK
}

@export var tutorial : TUTORIALS

var text : String
@onready var tittle: Label = $MarginContainer/Panel/VBoxContainer/Panel/Tittle
@onready var description: RichTextLabel = $MarginContainer/Panel/VBoxContainer/MarginContainer/Description

var is_in_tutorial: bool = false

func _ready() -> void:
	GlobalSignals.shot_tutorial.connect(shot_tutorial)
	set_process_input(false)
	visible = false

func shot_tutorial(new_tutorial: TUTORIALS) -> void:
	is_in_tutorial = true
	ActionIcons.change_input_type.connect(load_text)
	tutorial = new_tutorial
	match tutorial:
		TUTORIALS.MOVEMENT:
			CurrentGamePersistence.current_game_data["movement_tutorial"] = true
			CurrentGamePersistence._save_data()
		TUTORIALS.JUMP:
			CurrentGamePersistence.current_game_data["jump_tutorial"] = true
			CurrentGamePersistence._save_data()
		TUTORIALS.DASH:
			CurrentGamePersistence.current_game_data["dash_tutorial"] = true
			CurrentGamePersistence._save_data()
		TUTORIALS.ATTACK:
			CurrentGamePersistence.current_game_data["combat_tutorial"] = true
			CurrentGamePersistence._save_data()
	visible = true
	load_text()
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("ui_cancel"):
		await get_tree().process_frame
		is_in_tutorial = false
		ActionIcons.change_input_type.disconnect(load_text)
		set_process_input(false)
		visible = false
		GlobalSignals.main_character_resume.emit()

func load_text() -> void:
	match tutorial:
		TUTORIALS.MOVEMENT:
			tittle.text = tr("movement_tutorial_tittle")
			text = tr("movement_tutorial")
			text = text.format({"0": "[img=32x32]%s[/img]" % (ActionIconsCode.L_JOYSTICK.resource_path if ActionIcons.current_input_type == ActionIconsCode.INPUT_TYPE.joystick else ActionIconsCode.WASD.resource_path)})
		TUTORIALS.JUMP:
			tittle.text = tr("jump_tutorial_tittle")
			text = tr("jump_tutorial")
			text = text.format({"0": "[img=32x32]%s[/img]" % (ActionIconsCode.A.resource_path if ActionIcons.current_input_type == ActionIconsCode.INPUT_TYPE.joystick else ActionIconsCode.SPACE.resource_path)})
		TUTORIALS.DASH:
			tittle.text = tr("dash_tutorial_tittle")
			text = tr("dash_tutorial")
			text = text.format({"0": "[img=32x32]%s[/img]" % (ActionIconsCode.RT.resource_path if ActionIcons.current_input_type == ActionIconsCode.INPUT_TYPE.joystick else ActionIconsCode.SHIFT.resource_path)})
		TUTORIALS.ATTACK:
			tittle.text = tr("combat_tutorial_tittle")
			text = tr("combat_tutorial")
			text = text.format({"0": "[img=32x32]%s[/img]" % (ActionIconsCode.X.resource_path if ActionIcons.current_input_type == ActionIconsCode.INPUT_TYPE.joystick else ActionIconsCode.H.resource_path)})
			text = text.format({"1": "[img=32x32]%s[/img]" % (ActionIconsCode.Y.resource_path if ActionIcons.current_input_type == ActionIconsCode.INPUT_TYPE.joystick else ActionIconsCode.J.resource_path)})
			text = text.format({"2": "[img=32x32]%s[/img]" % (ActionIconsCode.O.resource_path if ActionIcons.current_input_type == ActionIconsCode.INPUT_TYPE.joystick else ActionIconsCode.K.resource_path)})
	description.text = text
