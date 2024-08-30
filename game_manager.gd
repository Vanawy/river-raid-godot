extends Node2D

#var time : float = 0

var game_score: float = 0

const LEVEL_SCORE: int = 1000
const KILL_SCORE: int = 500

@export var player: Jet
@export var level_manager: LevelManager
@export var enemy_spawner: EnemySpawner

@onready var free_cam: FreeCamController = $"../FreeCamController"

@export_category("UI")
@export var score_label: Label
@export var plus_points: PlusScore
@export var combo_label: Label

var difficulty_multiplier: float = 1
var spawn_score: float = -2

var can_spawn_enemies: bool = false
var is_paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	assert(player != null)
	assert(level_manager != null)
	assert(enemy_spawner != null)
	level_manager.level_changed.connect(enable_spawn)
	level_manager.level_started.connect(enable_spawn)
	level_manager.level_finished.connect(disable_spawn)
	player.died.connect(disable_spawn)
	
	combo_label.text = "X" + str(difficulty_multiplier)
	
	level_manager.level_changed.connect(func() -> void:
		_add_score(LEVEL_SCORE)
		difficulty_multiplier += 0.2
		combo_label.text = "X" + str(difficulty_multiplier)
	)
	
	_update_score_label()
	
	enemy_spawner.enemy_killed.connect(func(score: int, pos: Vector2) -> void:
		_add_score(score)
		print(pos)
	)
	
func _add_score(score: float) -> void:
	var x := score * difficulty_multiplier
	game_score += x
	plus_points.display_score(x)
	_update_score_label()

func _physics_process(delta: float) -> void:
	if can_spawn_enemies && !is_paused:
		spawn_score += delta * difficulty_multiplier
	#print(spawn_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#time += 1 * delta
	if spawn_score > 0 && can_spawn_enemies:
		spawn_score -= enemy_spawner.spawn_enemy(
			player, 
			level_manager.current_level, 
			difficulty_multiplier
		)

func _input(event: InputEvent) -> void:
	if event.is_released():
		if event.as_text() == "Escape":
			var tree := get_tree()
			tree.paused = !tree.paused
			is_paused = tree.paused
			if tree.paused:
				print("GAME PAUSED")
			else:
				print("GAME RESUMED")
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

func _update_score_label() -> void:
	var txt := str(game_score)
	txt = txt.pad_zeros(8)
	score_label.text = txt
