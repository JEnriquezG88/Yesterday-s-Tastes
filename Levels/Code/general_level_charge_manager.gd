extends LevelSections
class_name GeneralLevelSections

const LOBBY_PATH : String = "uid://c55jeqmc1lpm8"

func load_lobby() -> void:
	print("load lobby")
	load_section(LOBBY_PATH, 1)

func unload_lobby() -> void:
	print("unload lobby")
	unload_section(1)

@onready var charge_lobbie : Area3D = $ChargeLobby

func _ready() -> void:
	super._ready()
	load_lobby()
	connect_lobbie_signals()

func connect_lobbie_signals() -> void:
	charge_lobbie.body_exited.connect(_on_charge_lobbie_body_exited)

func _on_charge_lobbie_body_entered(_body: Node3D) -> void:
	load_lobby()

func _on_charge_lobbie_body_exited(_body: Node3D) -> void:
	charge_lobbie.body_entered.connect(_on_charge_lobbie_body_entered)
	unload_lobby()
