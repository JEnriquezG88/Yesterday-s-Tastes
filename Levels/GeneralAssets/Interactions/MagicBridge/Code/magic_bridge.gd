extends Node3D
class_name MagicBridge

@export var interaction_totem : FireTotem
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var bridge_light: StandardMaterial3D
@onready var bridge_lights: MeshInstance3D = $BridgeLights

@onready var colliders: Node3D = $Systems/Colliders


var _magic_door_light_intensity : float = 5.0
var _cinematic_timer_time : float = 0.8

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	if not interaction_totem.completed:
		animation_player.play("up_idle")
		interaction_totem.fire_door_finished.connect(_interact)
		_start_lights()
	else:
		animation_player.play("down_idle")
		colliders.queue_free()

func _start_lights() -> void:
	
	bridge_lights.set_surface_override_material(0, bridge_lights.get_active_material(0).duplicate())
	
	bridge_light = bridge_lights.get_active_material(0)
	
	bridge_light.emission_energy_multiplier = 0.0

func _interact() -> void:
	await get_tree().create_timer(_cinematic_timer_time).timeout
	GlobalSignals.change_camera_target.emit(self)
	await get_tree().create_timer(_cinematic_timer_time).timeout
	_change_light_intensity(bridge_light, _magic_door_light_intensity)
	await get_tree().create_timer(_cinematic_timer_time).timeout
	animation_player.play("DownAnimation")
	await animation_player.animation_finished
	colliders.queue_free()
	GlobalSignals.return_to_camera_original_target.emit()
	GlobalSignals.main_character_resume.emit()

func _change_light_intensity(light: StandardMaterial3D, final_value: float) -> void:
	var tween : Tween = create_tween()
	tween.tween_property(light, "emission_energy_multiplier", final_value, 0.2)
	await tween.finished
