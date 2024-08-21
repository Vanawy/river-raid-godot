@tool
extends Node2D

@export var explosion_preload: PackedScene = preload("res://explosion.tscn")
@export var explosion_area: Vector2 = Vector2(1,1)
@export var explosions_count: int = 1
@export var editor_color: Color = Color.CRIMSON


func spawn_explosions() -> void:
	var parent: Node2D = get_parent()
	for i in range(explosions_count):
		var explosion: Node2D = explosion_preload.instantiate()
		explosion.position = parent.position + position + Vector2(
			randf() * explosion_area.x,
			randf() * explosion_area.y
		)
		parent.add_sibling.call_deferred(explosion)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(Rect2(Vector2.ZERO, explosion_area), editor_color, false, 1)
