extends Node3D
class_name Ingredients



enum INGREDIENTS {
	NONE,
	KORN,
	CHEESE,
	COFFE
}
var main_character : CharacterController
@export var ingredient : INGREDIENTS = INGREDIENTS.NONE

@onready var rotation_item: Node3D = $RotationItem
@onready var place_holder: MeshInstance3D = $RotationItem/PlaceHolder

const KORN_PATH : String = "uid://demjy0gsdlhof"
const CHEESE_PATH : String = "uid://jqof7yeudcnp"
const COFFE_PATH : String = "uid://cada3fevy2ao7"
var ingredient_mesh : MeshInstance3D


func _ready() -> void:
	var is_item_obtained : bool = false
	match ingredient:
		INGREDIENTS.KORN:
			if CurrentGamePersistence.current_game_data["KornObtained"]:
				is_item_obtained = true
		INGREDIENTS.CHEESE:
			if CurrentGamePersistence.current_game_data["CheeseObtained"]:
				is_item_obtained = true
		INGREDIENTS.COFFE:
			if CurrentGamePersistence.current_game_data["CoffeObtained"]:
				is_item_obtained = true
	if is_item_obtained:
		queue_free()
	else:
		place_holder.queue_free()
		var load_mesh : ArrayMesh
		match ingredient:
			INGREDIENTS.KORN:
				load_mesh = load(KORN_PATH)
			INGREDIENTS.CHEESE:
				load_mesh = load(CHEESE_PATH)
			INGREDIENTS.COFFE:
				load_mesh = load(COFFE_PATH)
		ingredient_mesh = MeshInstance3D.new()
		ingredient_mesh.mesh = load_mesh
		rotation_item.add_child(ingredient_mesh)

func _process(delta: float) -> void:
	_round_item(delta)
	_round_lighs(delta)
	_process_character_animation_position()

func _round_item(delta: float) -> void:
	rotation_item.rotation.y += delta * 2


@onready var lights_array : Array[MeshInstance3D] = [
	$GodRays/Light01, $GodRays/Light02, $GodRays/Light03, $GodRays/Light04
]
var lights_velocity_array : Array[float] = [
	1.0, -0.8, 1.3, -2.0
]

func _round_lighs(delta: float) -> void:
	var index : int = 0
	for light in lights_array:
		light.rotation.z += lights_velocity_array[index] * delta
		index = index + 1


@onready var character_detector: Area3D = $CharacterDetector

func _process_character_animation_position() -> void:
	if not main_character: return
	
	global_position = main_character.cinematics_manager.ingredient_position.global_position
	scale = main_character.cinematics_manager.ingredient_position.scale

func _save_data() -> void:
	match ingredient:
		INGREDIENTS.KORN:
			CurrentGamePersistence.current_game_data["KornObtained"] = true
		INGREDIENTS.CHEESE:
			CurrentGamePersistence.current_game_data["CheeseObtained"] = true
		INGREDIENTS.COFFE:
			CurrentGamePersistence.current_game_data["CoffeObtained"] = true
	CurrentGamePersistence._save_data()

func _on_character_detector_body_entered(body: Node3D) -> void:
	character_detector.queue_free()
	_save_data()
	main_character = body as CharacterController
	GlobalSignals.stop_current_song.emit()
	main_character.cinematics_manager._on_get_ingredient()
	var tween : Tween = create_tween()
	tween.tween_property(self, "scale", Vector3.ZERO, 0.2)
	await tween.finished
