extends VBoxContainer
class_name ButtonsContainer

@export var current_first_element : Button

func change_first_element(new_first_element: Button) -> void:
	current_first_element = new_first_element

func first_element_focus() -> void:
	if not current_first_element: return
	current_first_element.grab_focus()
