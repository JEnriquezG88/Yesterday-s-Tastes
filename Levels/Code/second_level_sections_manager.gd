extends LevelSections
class_name  SecondLevelSectionManager

#@onready var charge_level_2_section_1: Area3D = 
#@onready var charge_level_2_section_2: Area3D = 
#@onready var charge_level_2_section_3: Area3D = 
@onready var charge_level_2_section_1: Area3D = $ChargeLevel2Section1
@onready var charge_level_2_section_2: Area3D = $ChargeLevel2Section2
@onready var charge_level_2_section_3: Area3D = $ChargeLevel2Section3

var current_section : int = 0

func _ready() -> void:
	super._ready()
	_connect_signals()

func _connect_signals() -> void:
	charge_level_2_section_1.body_entered.connect(_on_charge_level_2_section_1_body_entered)
	charge_level_2_section_1.body_exited.connect(_on_delete_level_2_section_1_body_entered)
	
	charge_level_2_section_2.body_entered.connect(_on_charge_level_2_section_2_body_entered)
	charge_level_2_section_2.body_exited.connect(_on_delete_level_2_section_2_body_entered)
	
	charge_level_2_section_3.body_entered.connect(_on_charge_level_2_section_3_body_entered)
	charge_level_2_section_3.body_exited.connect(_on_delete_level_2_section_3_body_entered)

#region Section 01

const SECTION_01_PATH : String = "uid://y1h5gvv2rmvp"

func _on_delete_level_2_section_1_body_entered(_body: Node3D) -> void:
	print("exited")
	unload_section(1)

func _on_charge_level_2_section_1_body_entered(_body: Node3D) -> void:
	print("Entered")
	load_section(SECTION_01_PATH, 1)

#endregion

const SECTION_02_PATH : String = "uid://cj20tdrlnjipp"

func _on_charge_level_2_section_2_body_entered(_body: Node3D) -> void:
	load_section(SECTION_02_PATH, 2)

func _on_delete_level_2_section_2_body_entered(_body: Node3D) -> void:
	unload_section(2)

const SECTION_03_PATH : String = "uid://da56m8pb5xe6"

func _on_charge_level_2_section_3_body_entered(_body: Node3D) -> void:
	load_section(SECTION_03_PATH, 3)

func _on_delete_level_2_section_3_body_entered(_body: Node3D) -> void:
	unload_section(3)

#region Load Logic
