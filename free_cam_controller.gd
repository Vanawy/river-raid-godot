extends Node2D
class_name FreeCamController

var zoom_percentage: float = 15
var max_zoom: float = 2.5
var max_unzoom: float = 0.4

var enabled: bool = false

@onready var camera: PhantomCamera2D = $FreeCamera
@onready var camera_target: Node2D = $CamTarget

const PRIORITY = 500
var cam_priority: int = 0

func _ready() -> void:
	cam_priority = camera.priority
	
func toggle() -> void:
	enabled = !enabled
	if enabled:
		camera.priority = PRIORITY
	else:
		camera.priority = cam_priority

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var me: InputEventMouseMotion = event
		if me.button_mask == MOUSE_BUTTON_LEFT:
			camera_target.position -= me.relative / camera.zoom

	if event is InputEventMouseButton:
		var me: InputEventMouseButton = event
		if me.is_pressed():
			if me.button_index == MOUSE_BUTTON_WHEEL_UP:
				camera.zoom += Vector2.ONE * zoom_percentage / 100
				if camera.zoom.x > max_zoom:
					camera.zoom = Vector2.ONE * max_zoom
					return
				position += get_local_mouse_position() / 10
			if me.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				camera.zoom -= Vector2.ONE * zoom_percentage / 100
				if camera.zoom.x < max_unzoom:
					camera.zoom = Vector2.ONE * max_unzoom

func _process(delta: float) -> void:
	if enabled:
		DisplayServer.cursor_set_shape(DisplayServer.CURSOR_DRAG)
