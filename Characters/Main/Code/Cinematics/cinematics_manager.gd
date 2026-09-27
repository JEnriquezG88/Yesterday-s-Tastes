extends Node
class_name CinematicsManager

@onready var character_controller: CharacterController = $"../.."
@onready var movement: Movement = $"../Movement"
@onready var ingredient_position: Node3D = $"../../Systems/Interactions/IngredientPosition"
@onready var ingredients_list: IngredientsList = $"../../UI/List"

func _ready() -> void:
	GlobalSignals.main_character_wait.connect(_on_character_wait)
	GlobalSignals.main_character_resume.connect(_on_character_resume)

func _on_character_wait() -> void:
	character_controller.current_state = CharacterController.STATES.WAITING
	movement.direction = Vector2.ZERO
	character_controller.animation_tree.set("parameters/Movement/Movement/conditions/walk", false)
	character_controller.animation_tree.set("parameters/Movement/Movement/conditions/idle", true)
	character_controller.velocity = Vector3.ZERO

func _on_character_resume() -> void:
	character_controller.current_state = CharacterController.STATES.MOVEMENT

func _on_get_ingredient() -> void:
	character_controller.current_state = CharacterController.STATES.CINEMATIC
	character_controller.animation_tree.set("parameters/GeneralStates/transition_request", "Cinematics")
	character_controller.rotation.y = 0.0
	character_controller.velocity = Vector3.ZERO
	GlobalSignals.load_lobby.emit()
	GlobalSignals.camera_zoom.emit(-2.0)

func return_to_lobby_position() -> void:
	GlobalSignals.play_next_song.emit()
	character_controller.global_position = Vector3(0.0, 0.0, 6.0)
	GlobalSignals.force_camera_position.emit()
	GlobalSignals.camera_zoom.emit(0.0)

func finish_cinematic() -> void:
	await get_tree().create_timer(0.5).timeout
	character_controller.animation_tree.set("parameters/GeneralStates/transition_request", "Movement")
	ingredients_list.start_list_menu()
