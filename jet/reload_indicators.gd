extends Node2D
class_name ReloadIndicators

@export var indicators_in_row: int = 2

@export var ammo_count: int = 3
@export var reload_time: float = 3

var indicators: Array[AnimatedSprite2D] = []
var loaded_ammo: Array[bool] = []

var reloading_id: int = -1;

@onready var reload_timer: Timer = $ReloadTimer
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var indicator: AnimatedSprite2D = $Indicator
	indicators.append(indicator)
	loaded_ammo.append(true)
	for i in range(1, ammo_count):
		var new_indicator: AnimatedSprite2D = indicator.duplicate()
		new_indicator.position = Vector2((i % indicators_in_row) * 4, 4 * int(i / indicators_in_row))
		indicator.add_sibling(new_indicator)
		indicators.append(new_indicator)
		loaded_ammo.append(true)
	
	if reload_time > 0:
		reload_timer.wait_time = reload_time
		reload_timer.timeout.connect(_rocket_loaded)
	else: 
		reload_timer.stop()

func fire() -> bool:
	var x := _get_loaded_rocket()
	if x >= 0:
		_fire(x)
		return true
	return false

func _get_loaded_rocket() -> int:
	var x: int = 0
	for is_loaded in loaded_ammo:
		if is_loaded:
			return x
		x += 1
	return -1

func _fire(n: int) -> void:
	loaded_ammo[n] = false
	if reloading_id == -1:
		reloading_id = n
	indicators[n].play("fire")
	await indicators[n].animation_finished
	indicators[n].play("empty")


func _physics_process(delta: float) -> void:
	_reload()
	
func _reload() -> void:
	if reload_time <= 0:
		return
	
	if reloading_id == -1:
		return
		
	if loaded_ammo[reloading_id]:
		reloading_id = (reloading_id + 1) % ammo_count
		return
	
	var current_indicator: AnimatedSprite2D = indicators[reloading_id]
	if current_indicator.animation == 'empty':
		current_indicator.play("load")
	
	if reload_timer.is_stopped():
		reload_timer.start()
	
func _rocket_loaded() -> void:
	if reloading_id == -1:
		return
	loaded_ammo[reloading_id] = true
	indicators[reloading_id].play("ready")
