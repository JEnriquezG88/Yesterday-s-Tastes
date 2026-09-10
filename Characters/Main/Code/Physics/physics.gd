extends Node
class_name Physics

var process_gravity : bool = true
@onready var character_controller: CharacterController = $"../.."

func _physics_process(delta: float) -> void:
	if not process_gravity: return
	if character_controller.current_state == CharacterController.STATES.DASH: return
	
	if not character_controller.is_on_floor():
		character_controller.velocity.y = character_controller.velocity.y - ProjectSettings.get_setting("physics/3d/default_gravity") * 7 * delta
		character_controller.velocity.y = clampf(character_controller.velocity.y, -20, 20)
