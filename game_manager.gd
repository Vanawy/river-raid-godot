extends Node2D

#var time : float = 0

@export var player: Jet
@export var level_manager: LevelManager
@export var enemy_spawner: EnemySpawner

@onready var free_cam: FreeCamController = $"../FreeCamController"

var difficulty_multiplier: float = 1

var spawn_score: float = -2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(player != null)
	assert(level_manager != null)
	assert(enemy_spawner != null)

func _physics_process(delta: float) -> void:
	spawn_score += delta * difficulty_multiplier

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#time += 1 * delta
	if spawn_score > 0:
		spawn_score -= enemy_spawner.spawn_enemy(player, level_manager.current_level)

func _input(event: InputEvent) -> void:
	if event.is_released():
		if event.as_text() == "F2":
			get_tree().reload_current_scene()
		if event.as_text() == "F3":
			player.death()
		if event.as_text() == "F4":
			free_cam.camera_target.global_position = player.global_position
			free_cam.toggle()
