extends Node2D

@export var detection_area : Area2D

@onready var rocket_tscn = preload("res://enemies/rocket.tscn")

func _ready() -> void:
	detection_area.body_entered.connect(target_detected)

func target_detected(target : Node2D):
	if not target is Jet:
		return
	print("target detected")
	await get_tree().create_timer(0.2).timeout
	print("launch rocket")
	launch_rocket(target)
	
func launch_rocket(target : Jet):
	var new_rocket = rocket_tscn.instantiate() as EnemyRocket
	get_tree().get_root().add_child.call_deferred(new_rocket)
	new_rocket.set_target(target)
	new_rocket.global_position = global_position
	new_rocket.global_rotation = -PI/2
