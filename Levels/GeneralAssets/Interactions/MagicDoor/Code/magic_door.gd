extends Node3D
class_name MagicDoorInteractuableObject


@onready var magic_door: Node3D = $magic_door

@onready var magic_door_light_01: StandardMaterial3D
@onready var magic_door_light_02: StandardMaterial3D
var _magic_door_light_intensity : float = 5.0

@onready var magic_door_light_01_parent: Node3D = $magic_door/magic_door_light_01
@onready var magic_door_light_02_parent: Node3D = $magic_door/magic_door_light_02

@export var fire_totem_01 : FireTotem
@export var fire_totem_02 : FireTotem

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	fire_totem_01.fire_door_finished.connect(_on_fire_totem_01_finish)
	fire_totem_02.fire_door_finished.connect(_on_fire_totem_02_finish)
	_start_lights()
	await get_tree().create_timer(0.5).timeout 
	if fire_totem_01.completed and fire_totem_02.completed:
		_charge_completed()

func _start_lights() -> void:
	var magic_door_light_01_child = magic_door_light_01_parent.get_child(0)
	var magic_door_light_02_child = magic_door_light_02_parent.get_child(0)
	
	magic_door_light_01_child.set_surface_override_material(0, magic_door_light_01_child.get_active_material(0).duplicate())
	magic_door_light_02_child.set_surface_override_material(0, magic_door_light_02_child.get_active_material(0).duplicate())
	
	magic_door_light_01 = magic_door_light_01_child.get_active_material(0)
	magic_door_light_02 = magic_door_light_02_child.get_active_material(0)
	
	magic_door_light_01.emission_energy_multiplier = 0.0
	magic_door_light_02.emission_energy_multiplier = 0.0
	

func _change_light_intensity(light: StandardMaterial3D, final_value: float) -> void:
	var tween : Tween = create_tween()
	tween.tween_property(light, "emission_energy_multiplier", final_value, 0.2)
	await tween.finished

var totems_active : int = 0

func _on_fire_totem_01_finish() -> void:
	totems_active = totems_active + 1
	timer.start()
	await timer.timeout
	GlobalSignals.change_camera_target.emit(self)
	timer.start()
	await timer.timeout
	_change_light_intensity(magic_door_light_01, _magic_door_light_intensity)
	timer.start()
	await timer.timeout
	_can_open_door()


func _on_fire_totem_02_finish() -> void:
	totems_active = totems_active + 1
	timer.start()
	await timer.timeout
	GlobalSignals.change_camera_target.emit(self)
	timer.start()
	await timer.timeout
	timer.start()
	_change_light_intensity(magic_door_light_02, _magic_door_light_intensity)
	await timer.timeout
	_can_open_door()

func _can_open_door() -> void:
	if totems_active == 2:
		animation_player.play("close_door")
		await animation_player.animation_finished
		GlobalSignals.return_to_camera_original_target.emit()
		GlobalSignals.main_character_resume.emit()
	else:
		GlobalSignals.return_to_camera_original_target.emit()
		GlobalSignals.main_character_resume.emit()

func _charge_completed() -> void:
	animation_player.play("close_door")
