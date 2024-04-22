extends Node2D
class_name LevelManager

var level_scene : PackedScene = preload("res://level.tscn")

@onready var current_level : Level = $Level
@onready var enemy_spawner : EnemySpawner = $EnemySpawner
var next_level : Level = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level.player_almost_reached_bridge.connect(generate_next_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func switch_level() -> void:
	current_level = next_level
	next_level = null
	enemy_spawner.spawn_jets(
		current_level, 
		10
	)

	

func generate_next_level()  -> void:
	var new_level: Level = level_scene.instantiate()
	new_level.global_position = Vector2(-10000, 0)
	add_child.call_deferred(new_level)
	new_level.player_almost_reached_bridge.connect(generate_next_level)
	next_level = new_level
	await next_level.level_created
	new_level.global_position = current_level.level_end.global_position
	next_level.bridge.destroyed.connect(switch_level)
