extends Node
class_name ActionIconsCode



const A = preload("uid://pj7c32pbuqrq")
const H = preload("uid://b8o4y4wuc6tlh")
const J = preload("uid://b8xgkvku7pumi")
const K = preload("uid://c473mtti4ruiq")
const L_JOYSTICK = preload("uid://1glcbrjssmlr")
const O = preload("uid://rln4fng51e11")
const RT = preload("uid://bkvk7ijdvgndc")
const SHIFT = preload("uid://cigiqx2vu3lky")
const SPACE = preload("uid://o6367eb6f44l")
const WASD = preload("uid://dgvdfm88oly8j")
const X = preload("uid://d0pdgnwbutq6p")
const Y = preload("uid://dg7o4d5b4vyvq")
const ESC = preload("uid://bteeqs013255f")

enum INPUT_TYPE {
	keyboard,
	joystick
}

var current_input_type : INPUT_TYPE = INPUT_TYPE.joystick

signal change_input_type

func _input(event: InputEvent) -> void:
	match current_input_type:
		INPUT_TYPE.joystick:
			if event is InputEventKey or event is InputEventMouse:
				current_input_type = INPUT_TYPE.keyboard
				change_input_type.emit()
		INPUT_TYPE.keyboard:
			if event is InputEventJoypadButton or event is InputEventJoypadMotion:
				current_input_type = INPUT_TYPE.joystick
				change_input_type.emit()
