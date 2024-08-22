extends Node2D
class_name LevelManager

var level_scene : PackedScene = preload("res://level.tscn")

@onready var current_level : Level = $Level
var next_level : Level = null

signal level_changed
signal level_finished
signal level_started

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_level_signals(current_level)
		
func setup_level_signals(level: Level) -> void:
	level.player_almost_reached_bridge.connect(generate_next_level)
	level.player_almost_reached_bridge.connect(func() -> void:
		level_finished.emit()
	)
	level.player_entered_level.connect(func() -> void:
		level_started.emit()
	)

func switch_level() -> void:
	current_level = next_level
	next_level = null
	setup_level_signals(current_level)
	level_changed.emit()

func generate_next_level()  -> void:
	var new_level: Level = level_scene.instantiate()
	new_level.global_position = Vector2(-10000, 0)
	add_child.call_deferred(new_level)
	next_level = new_level
	await next_level.level_created
	new_level.global_position = current_level.level_end.global_position
	next_level.bridge.destroyed.connect(switch_level)
