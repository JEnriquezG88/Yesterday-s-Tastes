extends Node3D
class_name EndCinematicManager


@onready var kitchen_utils_animation_player: AnimationPlayer = $Interactions/AnimationPlayer
@onready var camera_animation_player: AnimationPlayer = $Camera/AnimationPlayer
@onready var animation_player: AnimationPlayer = $Character/cinematic_character/AnimationPlayer
@onready var fade_manager: FadeManager = $CanvasLayer/FadeManager


func _ready() -> void:
	animation_player.play("EndAnimations/cook")
	kitchen_utils_animation_player.play("KitchenUtilsCook")
	camera_animation_player.play("EndAnimations/end_camera_cook_animation")


@onready var wand_hit_particles: HitParticles = $Character/cinematic_character/CharacterRig/Skeleton3D/wandController/wand/HitParticles

func shot_wand_particles() -> void:
	wand_hit_particles.shot_particles()


#region Cooking cinematic

@onready var waterfall_sound: AudioStreamPlayer3D = $WaterfallSound


@onready var plato_arepas: Node3D = $Items/PlatoArepas
@onready var kitchen_utils_armature: Node3D = $Interactions/KitchenUtilsArmature
@onready var waterfall: Node3D = $Interactions/Waterfall

var eat_cinematic_index : int = 0

func shot_eat_cinematic() -> void:
	eat_cinematic_index = eat_cinematic_index + 1
	
	
	await fade_manager._fade_out()
	plato_arepas.visible = true
	kitchen_utils_armature.visible = false
	await get_tree().create_timer(0.5).timeout
	match eat_cinematic_index:
		1:
			
			animation_player.play("EndAnimations/eat")
			camera_animation_player.play("EndAnimations/end_camera_cook_animation_eat")
		2:
			animation_player.play("EndAnimations/comer_gm")
			child_animation_player.play("ChildAnimations/child_comer")
			camera_animation_player.play("EndAnimations/end_camera_cook_animation_eat_gm")
	await fade_manager._fade_in()



@onready var flash_back_effect: TextureRect = $CanvasLayer/TextureRect
@onready var child_animation_player: AnimationPlayer = $Character/Child/AnimationPlayer
@onready var music: CinematicMusicManager = $Music

func shot_grandmother_cook_animation() -> void:
	#var tween: Tween = create_tween()
	#var original_db := AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	#await tween.finished
	music.play()
	plato_arepas.visible = false
	kitchen_utils_armature.visible = true
	flash_back_effect.visible = true
	_change_colors_to_grandmother()
	animation_player.play("EndAnimations/cook")
	child_animation_player.play("ChildAnimations/child_watch")
	child_animation_player.get_parent().visible = true
	kitchen_utils_animation_player.play("KitchenUtilsCook")
	camera_animation_player.play("EndAnimations/end_camera_cook_animation")

func shot_finish_animation() -> void:
	child_animation_player.get_parent().visible = false
	_change_colors_to_normal_witch()
	flash_back_effect.visible = false
	grandmother_glases.visible = false
	animation_player.play("EndAnimations/finish_flashback")
	camera_animation_player.play("EndAnimations/camera_finish_flashback")

func change_to_credits() -> void:
	await fade_manager._fade_out()
	get_tree().change_scene_to_file("uid://d1j82k0ad0xvu")

#endregion

@onready var eyes: MeshInstance3D = $Character/cinematic_character/CharacterRig/Skeleton3D/head/Eyes
@onready var body: MeshInstance3D = $Character/cinematic_character/CharacterRig/Skeleton3D/Body
@onready var hat: MeshInstance3D = $Character/cinematic_character/CharacterRig/Skeleton3D/Hat
@onready var legs: MeshInstance3D = $Character/cinematic_character/CharacterRig/Skeleton3D/Legs
@onready var hair: MeshInstance3D = $Character/cinematic_character/CharacterRig/Skeleton3D/Hair

@onready var grandmother_glases: Node3D = $Character/cinematic_character/CharacterRig/Skeleton3D/head/grandmother_glases

var original_eyes_material : StandardMaterial3D
var grandmother_eyes_material : StandardMaterial3D = preload("uid://cg10vef1opnk1")

var original_body_material : StandardMaterial3D
var grandmother_body_material : StandardMaterial3D = preload("uid://dveqmw2eexgc8")

func _change_colors_to_grandmother() -> void:
	original_eyes_material = eyes.get_active_material(0)
	original_body_material = body.get_active_material(0)
	
	grandmother_glases.visible = true
	body.set_surface_override_material(0, grandmother_body_material)
	legs.set_surface_override_material(0, grandmother_body_material)
	hair.set_surface_override_material(0, grandmother_body_material)
	hat.set_surface_override_material(0, grandmother_body_material)
	eyes.set_surface_override_material(0, grandmother_eyes_material)

func _change_colors_to_normal_witch() -> void:
	grandmother_glases.visible = false
	body.set_surface_override_material(0, original_body_material)
	legs.set_surface_override_material(0, original_body_material)
	hair.set_surface_override_material(0, original_body_material)
	hat.set_surface_override_material(0, original_body_material)
	eyes.set_surface_override_material(0, original_eyes_material)
