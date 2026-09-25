extends CharacterBody3D
class_name CharacterController

@onready var animation_tree: AnimationTree = $AnimationTree

enum STATES {
	NONE,
	MOVEMENT,
	JUMP,
	DASH,
	MAGIC,
	CINEMATIC,
	DAMAGE,
	WAITING,
}

var current_state : STATES = STATES.MOVEMENT


@onready var cinematics_manager: CinematicsManager = $Code/CinematicsManager
