extends Node2D
class_name AALauncher

@export var detection_area : Area2D
@onready var rocket_tscn: PackedScene = preload("res://enemies/rocket.tscn")
@onready var lock: AnimatedSprite2D = $lock
@onready var current_target: Node2D = null;

var difficulty: float = 1

func _ready() -> void:
	detection_area.body_entered.connect(target_detected)
	lock.visible = false

func target_detected(target : Node2D) -> void:
	if not target is Jet:
		return
	print("target detected")
	current_target = target
	var rockets_shot: float = 0
	var diff: float = difficulty
	while diff > 0:
		if diff > 1:
			lock.visible = true
			lock.play("lock")
			lock.set_frame_and_progress(0, 0)
			await lock.animation_finished
			launch_rocket(target)
			rockets_shot += 1
		elif randf() < diff:
			lock.visible = true
			lock.play("lock")
			lock.set_frame_and_progress(0, 0)
			await lock.animation_finished
			launch_rocket(target)
			rockets_shot += 1
			
		lock.visible = false
		diff = difficulty - rockets_shot
		
	
func launch_rocket(target : Jet) -> void:
	print("launch rocket")
	var new_rocket: EnemyRocket = rocket_tscn.instantiate()
	get_tree().get_root().add_child.call_deferred(new_rocket)
	new_rocket.set_target(target)
	new_rocket.global_position = global_position
	new_rocket.global_rotation = -PI/2

func _physics_process(_delta: float) -> void:
	if current_target == null:
		return
	lock.global_position = current_target.global_position
