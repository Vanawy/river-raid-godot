extends Node2D

var time : float = 0

@export var player: Jet
@export var level_manager: LevelManager
@export var enemy_spawner: EnemySpawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(player != null)
	assert(level_manager != null)
	assert(enemy_spawner != null)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += 1 * delta
	if randf() < 0.005:
		enemy_spawner.spawn_enemy(player, level_manager.current_level)

func _input(event: InputEvent) -> void:
	if event.as_text() == "F2":
		get_tree().reload_current_scene()
	if event.as_text() == "F3":
		player.death()
