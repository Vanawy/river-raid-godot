extends Node2D
class_name EnemySpawner


func spawn_jets(bot_left: Node2D, top_right: Node2D, count: int):
	var spawn_area = Vector2(
		top_right.position.x - bot_left.position.x,
		abs(bot_left.position.y - top_right.position.y)
	)

	var enemy_jet_scene = preload("res://enemies/jet/enemy_jet.tscn")

	for i in range(count):
		var pos = bot_left.global_position + Vector2(
			randf_range(0, spawn_area.x),
			-randf_range(0, spawn_area.y),
		)

		var enemy = enemy_jet_scene.instantiate() as EnemyJet
		enemy.global_position = pos
		enemy.rotate(PI)
		add_sibling(enemy)
		

		print("enemy spawned at " + str(pos.x) + ", " + str(pos.y))
