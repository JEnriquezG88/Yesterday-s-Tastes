extends LevelSections
class_name  ThirdLevelSectionManager

@onready var charge_level_3_section_1: Area3D = $ChargeLevel3Section1
@onready var charge_level_3_section_2: Area3D = $ChargeLevel3Section2
@onready var charge_level_3_section_3: Area3D = $ChargeLevel3Section3
@onready var charge_level_3_section_4: Area3D = $ChargeLevel3Section4
@onready var charge_level_3_section_5: Area3D = $ChargeLevel3Section5



var current_section : int = 0

func _ready() -> void:
	super._ready()
	_connect_signals()

func _connect_signals() -> void:
	charge_level_3_section_1.body_entered.connect(_on_charge_level_3_section_1_body_entered)
	charge_level_3_section_1.body_exited.connect(_on_delete_level_3_section_1_body_entered)
	
	charge_level_3_section_2.body_entered.connect(_on_charge_level_3_section_2_body_entered)
	charge_level_3_section_2.body_exited.connect(_on_delete_level_3_section_2_body_entered)
	
	charge_level_3_section_3.body_entered.connect(_on_charge_level_3_section_3_body_entered)
	charge_level_3_section_3.body_exited.connect(_on_delete_level_3_section_3_body_entered)
	
	charge_level_3_section_4.body_entered.connect(_on_charge_level_3_section_4_body_entered)
	charge_level_3_section_4.body_exited.connect(_on_delete_level_3_section_4_body_entered)
	
	charge_level_3_section_5.body_entered.connect(_on_charge_level_3_section_5_body_entered)
	charge_level_3_section_5.body_exited.connect(_on_delete_level_3_section_5_body_entered)

#region Section 01

const SECTION_01_PATH : String = "uid://y3h6c25ly0t0"

func _on_delete_level_3_section_1_body_entered(_body: Node3D) -> void:
	print("exited")
	unload_section(1)

func _on_charge_level_3_section_1_body_entered(_body: Node3D) -> void:
	print("Entered")
	load_section(SECTION_01_PATH, 1)

#endregion

const SECTION_02_PATH : String = "uid://dtuc6cegecwg2"

func _on_charge_level_3_section_2_body_entered(_body: Node3D) -> void:
	load_section(SECTION_02_PATH, 2)

func _on_delete_level_3_section_2_body_entered(_body: Node3D) -> void:
	unload_section(2)

const SECTION_03_PATH : String = "uid://bxvt7mucmlrc2"

func _on_charge_level_3_section_3_body_entered(_body: Node3D) -> void:
	load_section(SECTION_03_PATH, 3)

func _on_delete_level_3_section_3_body_entered(_body: Node3D) -> void:
	unload_section(3)

const SECTION_04_PATH : String = "uid://cegu75i6jk83v"

func _on_charge_level_3_section_4_body_entered(_body: Node3D) -> void:
	load_section(SECTION_04_PATH, 4)

func _on_delete_level_3_section_4_body_entered(_body: Node3D) -> void:
	unload_section(4)

const SECTION_05_PATH : String = "uid://dy7ynww11jkop"

func _on_charge_level_3_section_5_body_entered(_body: Node3D) -> void:
	load_section(SECTION_05_PATH, 5)

func _on_delete_level_3_section_5_body_entered(_body: Node3D) -> void:
	unload_section(5)

#region Load Logic
