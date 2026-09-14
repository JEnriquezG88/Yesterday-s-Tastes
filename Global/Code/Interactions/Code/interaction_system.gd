extends Node3D
class_name InteractionSystem


const X = preload("uid://d0pdgnwbutq6p")
const Y = preload("uid://dg7o4d5b4vyvq")
const O = preload("uid://rln4fng51e11")

@onready var icon: MeshInstance3D = $Icon

@export var _interaction_button : MagicSystem.MAGIC_TYPES = MagicSystem.MAGIC_TYPES.NONE

@onready var detection_area: Area3D = $DetectionArea

@export var interactuable_object : InteractuableObject
@onready var block_path: StaticBody3D = $BlockPath

signal finish_signal

func _ready() -> void:
	match _interaction_button:
		MagicSystem.MAGIC_TYPES.ICE:
			icon.get_surface_override_material(0).albedo_texture = X
		MagicSystem.MAGIC_TYPES.FIRE:
			icon.get_surface_override_material(0).albedo_texture = Y
		MagicSystem.MAGIC_TYPES.BROKE:
			icon.get_surface_override_material(0).albedo_texture = O
	icon.visible = false

func _on_detection_area_body_entered(_body: Node3D) -> void:
	icon.visible = true
	GlobalSignals.shot_magic.connect(_on_magic_shot)

func _on_detection_area_body_exited(_body: Node3D) -> void:
	icon.visible = false
	GlobalSignals.shot_magic.disconnect(_on_magic_shot)

var magic_calls : int = 0

func _on_magic_shot(magic_type: MagicSystem.MAGIC_TYPES) -> void:
	if not _interaction_button == magic_type: return
	
	magic_calls = magic_calls + 1
	if magic_calls < 2:
		icon.visible = false
	else:
		if interactuable_object: interactuable_object.interact()
		finish_signal.emit()
		_disable_system()

func charge_completed() -> void:
	if interactuable_object: interactuable_object.charge_completed()
	_disable_system()

func _disable_system() -> void:
	block_path.queue_free()
	GlobalSignals.shot_magic.disconnect(_on_magic_shot)
	detection_area.body_entered.disconnect(_on_detection_area_body_entered)
	detection_area.body_exited.disconnect(_on_detection_area_body_exited)
