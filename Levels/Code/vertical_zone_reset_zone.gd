extends Area3D
class_name VerticalZoneResetZone


@export var group : String = ""

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(_body: Node3D) -> void:
	print("body entered")
	for temporal_platform in get_tree().get_nodes_in_group(group):
		temporal_platform.reset_platform()
