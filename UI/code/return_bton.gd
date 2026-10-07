extends TextureRect
class_name ReturnButton

func _ready() -> void:
	change_bton_texture()
	ActionIcons.change_input_type.connect(change_bton_texture)


func change_bton_texture() -> void:
	match ActionIcons.current_input_type:
		ActionIconsCode.INPUT_TYPE.joystick:
			texture = ActionIcons.O
		ActionIconsCode.INPUT_TYPE.keyboard:
			texture = ActionIcons.ESC
