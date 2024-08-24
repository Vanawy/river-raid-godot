extends Node2D
class_name Rockets

const ROCKETS_IN_ROW: int = 2

@export var rockets_count: int = 3

var indicators: Array[AnimatedSprite2D] = []
var loaded_rockets: Array[bool] = []

var reloading_rocket: int = -1;

@onready var reload_timer: Timer = $ReloadTimer
	
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
	
	reload_timer.timeout.connect(_rocket_loaded)

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
	if reloading_rocket == -1:
		reloading_rocket = n
	indicators[n].play("fire")
	await indicators[n].animation_finished
	indicators[n].play("load")
	indicators[n].pause()


func _physics_process(delta: float) -> void:
	_reload_rockets()
	
func _reload_rockets() -> void:
	if reloading_rocket == -1:
		return
		
	if loaded_rockets[reloading_rocket]:
		reloading_rocket = (reloading_rocket + 1) % rockets_count
		return
		
	if reload_timer.is_stopped():
		reload_timer.start()
		
	var indicator: AnimatedSprite2D = indicators[reloading_rocket]
	if indicator.animation != "load":
		return
	indicator.set_frame_and_progress(
		int(indicator.sprite_frames.get_frame_count("load") 
			* (reload_timer.wait_time - reload_timer.time_left)),
		0
	)
	
func _rocket_loaded() -> void:
	if reloading_rocket == -1:
		return
	loaded_rockets[reloading_rocket] = true
	indicators[reloading_rocket].play("ready")
