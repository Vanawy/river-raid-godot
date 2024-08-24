extends Node2D
class_name Rockets

const ROCKETS_IN_ROW: int = 3

@export var rockets_count: int = 3

var indicators: Array[AnimatedSprite2D] = []
var loaded_rockets: Array[bool] = []
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var indicator: AnimatedSprite2D = $Indicator
	indicators.append(indicator)
	loaded_rockets.append(true)
	for i in range(1, rockets_count):
		var new_indicator: AnimatedSprite2D = indicator.duplicate()
		new_indicator.position = Vector2((i % ROCKETS_IN_ROW) * 4, 4 * int(i / ROCKETS_IN_ROW))
		indicator.add_sibling(new_indicator)
		indicators.append(new_indicator)
		loaded_rockets.append(true)
		

func fire() -> bool:
	var x := _get_loaded_rocket()
	if x >= 0:
		_fire_rocket(x)
		return true
	return false

func _get_loaded_rocket() -> int:
	var x: int = 0
	for is_loaded in loaded_rockets:
		if is_loaded:
			return x
		x += 1
	return -1

func _fire_rocket(n: int) -> void:
	loaded_rockets[n] = false
	indicators[n].play("fire")
	await indicators[n].animation_finished
	indicators[n].play("load")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
