extends Node
class_name FaceTexturesController

@export var mesehs_attachments: Dictionary[MeshInstance3D, BoneAttachment3D] = {}

func _ready() -> void:
	for mesh: MeshInstance3D in mesehs_attachments:
		mesh.set_surface_override_material(0, mesh.get_active_material(0).duplicate())

func _process(delta: float) -> void:
	for mesh: MeshInstance3D in mesehs_attachments:
		var attachment : BoneAttachment3D = mesehs_attachments[mesh]
		
		var offset : Vector3 = Vector3(
			round(-attachment.position.y / 0.25) * 0.25,
			round(attachment.position.x / 0.25) * 0.25,
			0.0
		)
		
		mesh.get_active_material(0).uv1_offset = offset
