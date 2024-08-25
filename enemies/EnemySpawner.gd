extends Node2D
class_name EnemySpawner

var spawn_area_size : Vector2;
var spawn_area : Area2D;

@onready var enemy_jet_scene: PackedScene = preload("res://enemies/jet/enemy_jet.tscn")
@onready var aa_boat_scene: PackedScene = preload("res://enemies/boat/boat.tscn")


func _ready() -> void:
	#add_child()
	pass
	
func spawn_enemy(player: Jet, level: Level, difficulty: float) -> float:
	var k: float = randf()
	if k < 0.3:
		var offset: Vector2 = Vector2.UP * 256
		spawn_aa_boat(player.global_position + offset, level, difficulty)
		return 2
	if k < 0.7:
		var offset: Vector2 = Vector2.UP * 512
		spawn_jet_formation(player.global_position + offset, level)
		return 3
	else:
		var offset: Vector2 = Vector2.UP * 512 + Vector2.RIGHT * randf_range(-32, 32)
		spawn_jet(player.global_position + offset, level)
		return 1 + randf() * 1
	
	
func spawn_jet_formation(global_pos: Vector2, level: Level) -> void:
	spawn_jet(global_pos, level, true)
	spawn_jet(global_pos + Vector2.UP * 32 + Vector2.LEFT * 16, level, true)
	spawn_jet(global_pos + Vector2.UP * 32 + Vector2.RIGHT * 16, level, true)
	
func spawn_jet(global_pos: Vector2, level: Level, remove_random: bool = false) -> void:
		var enemy: EnemyJet = enemy_jet_scene.instantiate()
		enemy.position = level.to_local(global_pos)
		enemy.rotate(PI)
		if remove_random:
			enemy.time = 0
		level.add_child.call_deferred(enemy)
		print("enemy jet spawned")

func spawn_aa_boat(global_pos: Vector2, level: Level, difficulty: float) -> void:
		var enemy: AABoat = aa_boat_scene.instantiate()
		var boat_width_tiles: int = 2
		enemy.position = level.get_first_spawn_horizontal(global_pos, boat_width_tiles)
		level.add_child.call_deferred(enemy)
		enemy.set_difficulty.call_deferred(difficulty)
		print("aa boat spawned")
		print(enemy.position)
	
#func _draw() -> void: 
	#if !enemies_spawned:
		#queue_redraw()
		#return
	#draw_rect(Rect2(level.bot_left.position, spawn_area), Color.GREEN, false, 10.0);
