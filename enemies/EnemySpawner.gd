extends Node2D
class_name EnemySpawner

var spawn_area_size : Vector2;
var spawn_area : Area2D;

@onready var enemy_jet_scene: PackedScene = preload("res://enemies/jet/enemy_jet.tscn")

func _ready() -> void:
	#add_child()
	pass
	
func spawn_enemy(player: Jet, level: Level) -> int:
	spawn_jet(player.global_position + Vector2.UP * 512 + Vector2.RIGHT * randf_range(-64, 64), level)
	return 0
	

func spawn_jets(level: Level, count: int) -> void:
	spawn_area_size = level.top_right.position - level.bot_left.position
	# spawn_area_size /= Vector2()

	for i: int  in range(count):
		var pos := Vector2(
			randf_range(0, spawn_area_size.x),
			randf_range(0, spawn_area_size.y),
		)
		
		spawn_jet(level.bot_left.global_position + pos, level)
	#enemies_spawned = true
	
func spawn_jet(global_pos: Vector2, level: Level) -> void:
		var enemy: EnemyJet = enemy_jet_scene.instantiate()
		enemy.position = level.to_local(global_pos)
		enemy.rotate(PI)
		level.add_child.call_deferred(enemy)
		print("enemy spawned at " + str(enemy.global_position.x) + ", " + str(enemy.global_position.y))

#func _draw() -> void: 
	#if !enemies_spawned:
		#queue_redraw()
		#return
	#draw_rect(Rect2(level.bot_left.position, spawn_area), Color.GREEN, false, 10.0);
