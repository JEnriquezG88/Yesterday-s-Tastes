extends Node3D
class_name InteractionSystem

@onready var icon: MeshInstance3D = $Icon

@export var _interaction_button : MagicSystem.MAGIC_TYPES = MagicSystem.MAGIC_TYPES.NONE

@onready var detection_area: Area3D = $DetectionArea

@export var interactuable_object : InteractuableObject
@onready var block_path: StaticBody3D = $BlockPath

@export var obstacle : bool = true
signal finish_signal

func _ready() -> void:
	ActionIcons.change_input_type.connect(_change_icon_types)
	if not obstacle:
		block_path.queue_free()
	icon.visible = false
	if _interaction_button != MagicSystem.MAGIC_TYPES.UP:
		set_process_input(false)

func _on_detection_area_body_entered(_body: Node3D) -> void:
	_change_icon_types()
	icon.visible = true
	GlobalSignals.shot_magic.connect(_on_magic_shot)

func _change_icon_types() -> void:
	print("change_icon_type")
	match _interaction_button:
		MagicSystem.MAGIC_TYPES.ICE:
			print("ice")
			match ActionIcons.current_input_type:
				ActionIconsCode.INPUT_TYPE.joystick:
					print("joystick")
					icon.get_surface_override_material(0).albedo_texture = ActionIcons.X
				ActionIconsCode.INPUT_TYPE.keyboard:
					print("keyboard")
					icon.get_surface_override_material(0).albedo_texture = ActionIcons.H
		MagicSystem.MAGIC_TYPES.FIRE:
			print("fire")
			match ActionIcons.current_input_type:
				ActionIconsCode.INPUT_TYPE.joystick:
					print("joystick")
					icon.get_surface_override_material(0).albedo_texture = ActionIcons.Y
				ActionIconsCode.INPUT_TYPE.keyboard:
					print("keyboard")
					icon.get_surface_override_material(0).albedo_texture = ActionIcons.J
		MagicSystem.MAGIC_TYPES.BROKE:
			print("broke")
			match ActionIcons.current_input_type:
				ActionIconsCode.INPUT_TYPE.joystick:
					print("joystick")
					icon.get_surface_override_material(0).albedo_texture = ActionIcons.O
				ActionIconsCode.INPUT_TYPE.keyboard:
					print("keyboard")
					icon.get_surface_override_material(0).albedo_texture = ActionIcons.K

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
	if block_path: block_path.queue_free()
	GlobalSignals.shot_magic.disconnect(_on_magic_shot)
	detection_area.body_entered.disconnect(_on_detection_area_body_entered)
	detection_area.body_exited.disconnect(_on_detection_area_body_exited)
