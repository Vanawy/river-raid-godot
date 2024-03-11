extends Node2D
class_name EnemySpawner

var enemy_jet_scene = preload("res://enemies/jet/enemy_jet_fix.tscn")


func spawn_jets(bot_left: Node2D, top_right: Node2D, count: int):
	var spawn_area = bot_left.position - top_right.position

	for i in range(count):
		var pos = bot_left.position + Vector2(
			randf_range(0, spawn_area.x),
			randf_range(0, spawn_area.y),
		)

		var enemy = enemy_jet_scene.instantiate() as EnemyJet;
		enemy.global_position = pos
		enemy.rotate(PI)
