extends Node2D
class_name LevelManager

var level_scene = preload("res://level.tscn")

@onready var current_level : Level = $Level
var next_level : Level = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level.player_almost_reached_bridge.connect(generate_next_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func switch_level():
	current_level = next_level
	next_level = null

func generate_next_level():
	var new_level = level_scene.instantiate() as Level
	new_level.global_position = Vector2(-10000, 0)
	add_child.call_deferred(new_level)
	new_level.player_almost_reached_bridge.connect(generate_next_level)
	next_level = new_level
	await next_level.level_created
	new_level.global_position = current_level.level_end.global_position
	next_level.bridge.destroyed.connect(switch_level)
