extends Node2D
class_name EnemySpawner

var spawn_area : Vector2;
var level : Level;
var enemies_spawned: bool = false;

@onready var enemy_jet_scene: PackedScene = preload("res://enemies/jet/enemy_jet.tscn")

func spawn_jets(_level: Level, count: int) -> void:
	level = _level
	spawn_area = level.top_right.position - level.bot_left.position

	for i: int  in range(count):
		var pos := Vector2(
			randf_range(0, spawn_area.x),
			randf_range(0, spawn_area.y),
		)

		var enemy: EnemyJet = enemy_jet_scene.instantiate()
		enemy.position = pos
		enemy.rotate(PI)
		level.add_child.call_deferred(enemy)
		

		print("enemy spawned at " + str(enemy.global_position.x) + ", " + str(enemy.global_position.y))
	
	enemies_spawned = true

func _draw() -> void: 
	if !enemies_spawned:
		queue_redraw()
		return
	draw_rect(Rect2(level.position, spawn_area), Color.GREEN, false, 10.0);