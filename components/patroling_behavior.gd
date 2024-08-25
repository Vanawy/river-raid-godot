extends Node2D


@onready var raycast: RayCast2D = $RayCast2D

@export var speed: float = 8

var parent: Node2D

func _ready() -> void:
	parent = get_parent()
	assert(parent is Node2D)

func _physics_process(delta: float) -> void:
	
	if raycast.is_colliding():
		parent.rotate(PI)
	
	parent.move_local_x(speed * delta)
