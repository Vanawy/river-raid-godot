extends Node2D

@export var lvl_manager: LevelManager;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lvl_manager.current_level.bridge.destroyed.connect(queue_free)
