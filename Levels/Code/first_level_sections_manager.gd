extends LevelSections
class_name FirstLevelSectionManager

@onready var delet_level: Area3D = $DeletLevel

@onready var charge_level_1_section_1: Area3D = $ChargeLevel1Section1
@onready var charge_level_1_section_2: Area3D = $ChargeLevel1Section2

var current_section : int = 0

func _ready() -> void:
	super._ready()
	_connect_signals()

func _connect_signals() -> void:
	charge_level_1_section_1.body_entered.connect(_on_charge_level_1_section_1_body_entered)
	charge_level_1_section_1.body_exited.connect(on_delet_level_body_entered)
	
	charge_level_1_section_2.body_entered.connect(_on_charge_level_1_section_2_body_entered)
	charge_level_1_section_2.body_exited.connect(_on_delete_level_1_section_2_body_entered)

#region Section 01

const SECTION_01_PATH : String = "uid://dgvggn7vvk2l7"

func on_delet_level_body_entered(_body: Node3D) -> void:
	unload_section(1)

func _on_charge_level_1_section_1_body_entered(_body: Node3D) -> void:
	load_section(SECTION_01_PATH, 1)

#endregion

const SECTION_02_PATH : String = "uid://c61vwfi2rv6q3"

func _on_charge_level_1_section_2_body_entered(_body: Node3D) -> void:
	load_section(SECTION_02_PATH, 2)

func _on_delete_level_1_section_2_body_entered(_body: Node3D) -> void:
	unload_section(2)


#region Load Logic
