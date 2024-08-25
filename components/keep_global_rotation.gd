extends Node2D


var initial_rotation: float
var parent: Node2D

func _ready() -> void:
	parent = get_parent()
	initial_rotation = parent.global_rotation

func _physics_process(delta: float) -> void:
	parent.global_rotation = initial_rotation
