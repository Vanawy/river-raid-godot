extends Node2D

#var time : float = 0

@export var player: Jet
@export var level_manager: LevelManager
@export var enemy_spawner: EnemySpawner

@onready var free_cam: FreeCamController = $"../FreeCamController"

var difficulty_multiplier: float = 1
var spawn_score: float = -2

var can_spawn_enemies: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(player != null)
	assert(level_manager != null)
	assert(enemy_spawner != null)
	level_manager.level_changed.connect(enable_spawn)
	level_manager.level_started.connect(enable_spawn)
	level_manager.level_finished.connect(disable_spawn)
	player.died.connect(disable_spawn)

func _physics_process(delta: float) -> void:
	if can_spawn_enemies:
		spawn_score += delta * difficulty_multiplier
	#print(spawn_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#time += 1 * delta
	if spawn_score > 0 && can_spawn_enemies:
		spawn_score -= enemy_spawner.spawn_enemy(player, level_manager.current_level)

func _input(event: InputEvent) -> void:
	if event.is_released():
		#if event.as_text() == "F1":
			#var tree := get_tree()
			#tree.paused = !tree.paused
			#if tree.paused:
				#print("GAME PAUSED")
			#else:
				#print("GAME RESUMED")
		if event.as_text() == "F2":
			get_tree().reload_current_scene()
		if event.as_text() == "F3":
			player.death()
		if event.as_text() == "F4":
			free_cam.camera_target.global_position = player.global_position
			free_cam.toggle()

func enable_spawn() -> void:
		print_rich("[color=red][b]ENEMIES NOW SPAWN![/b][/color]")
		can_spawn_enemies = true
	
func disable_spawn() -> void:
		print_rich("[color=green][b]ENEMIES chill![/b][/color]")
		can_spawn_enemies = false
