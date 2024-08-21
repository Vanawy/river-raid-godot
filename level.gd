extends Node2D
class_name Level

static var count: int = 0
var level_id: int = 0

signal player_almost_reached_bridge
signal level_created
signal player_entered_level

var cell_size: Vector2 = Vector2(16, 16)

@onready var tilemap_layer: TileMapLayer = $Layer0

@onready var bot_left: Node2D = $Bot
@onready var top_right: Node2D = $Top
@onready var level_end: Node2D = $LevelEnd
@onready var bridge : Enemy = $Bridge/Bridge

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Level.count += 1
	level_id = Level.count
	

	print("generation - start")
	generate_level()
	print("generation - end")
	
	var unload_area: Area2D = $UnloadLevelTrigger
	unload_area.body_entered.connect(func (_body: Node2D) -> void:
		print("level " + str(level_id) + " destroyed")
		queue_free()
	)
	
	var level_enter_area: Area2D = $LevelEndCloseTrigger
	level_enter_area.body_entered.connect(func (_body: Node2D) -> void:
		print("player entered level")
		player_entered_level.emit()
	)
	
	var level_end_area: Area2D = $LevelEndCloseTrigger
	level_end_area.body_entered.connect(func (_body: Node2D) -> void:
		print("player almost reached level end")
		player_almost_reached_bridge.emit()
	)
	
	print("level " + str(level_id) + "created")

	level_created.emit()
	
func get_closest_spawn_horizontal(global_pos: Vector2, width: int = 1) -> Vector2:
	var bot_left_coordinates: Vector2 = tilemap_layer.local_to_map(bot_left.position)
	bot_left_coordinates.y -= 1
	var grid_size : Vector2 = abs((bot_left.position - top_right.position) / cell_size)
	
	var x_start := bot_left_coordinates.x
	
	var pos := tilemap_layer.to_local(global_pos)
	var local := tilemap_layer.local_to_map(pos)
	assert(local.x >= x_start || local.x < x_start + grid_size.x)
	
	var n: int = 0
	for x in range(grid_size.x):
		var map_pos := Vector2i(x_start + x, local.y)
		if !tilemap_layer.get_cell_tile_data(map_pos):
			n += 1
		if n >= width:
			return tilemap_layer.map_to_local(map_pos)
	
	return Vector2.ZERO
	
	
func generate_level() -> void:
	
	var bot_left_coordinates: Vector2 = tilemap_layer.local_to_map(bot_left.position)
	bot_left_coordinates.y -= 1
	
	var grid_size : Vector2 = abs((bot_left.position - top_right.position) / cell_size)
		
	var displacement_noise : FastNoiseLite = FastNoiseLite.new()
	#displacement_noise.seed = 1231 + Level.count
	displacement_noise.seed = int(Time.get_unix_time_from_system()) + Level.count
	
	var width_noise : FastNoiseLite = FastNoiseLite.new()
	#width_noise.seed = 4365 + Level.countjet
	width_noise.seed = int(Time.get_unix_time_from_system()) + 1090 + Level.count
	
	#for i in range(0, 11):
		#print(curve(i / 10.0))
		#print(noise.get_noise_1d(i) * curve(i / 10.0))
		
	var image := Image.create(int(grid_size.x), int(grid_size.y), false, Image.FORMAT_RGBA8);

	image.fill(Color.BLACK)
	
	var curve_color := Color.WHITE
	curve_color.a = 0.3
	var rand_color := Color.RED
	rand_color.a = 0.3
	var comb_color := Color.GOLD
	comb_color.a = 0.3
	var width_color := Color.BLUE
	width_color.a = 0.3
	
	var tree := get_tree()
	
	for y in range(grid_size.y):
		if tree:
			await tree.process_frame
			
		var yn: float = y / grid_size.y
		var c := curve(yn)
		var r := displacement_noise.get_noise_1d(y) / 2
		var displacement_n := 0.5 + r * c * 0.7
		var displacement := displacement_n * grid_size.x
		
		var min_width := 2
		var max_width := 8
		var width := min_width \
			+ absf(width_noise.get_noise_1d(y)) * c \
			* (max_width - min_width)
							
		var left_b := displacement - width
		var right_b := displacement + width
			
		
		for x in range(grid_size.x):
			var xn: float = x / grid_size.x
			var color := Color.BLACK
			var place_tile := true
			
			#if xn < c:
				#color = color.blend(curve_color)
			#if xn < r:
				#color = color.blend(rand_color)
			if xn < displacement_n:
				color = color.blend(comb_color)
			if x < width * c:
				color = color.blend(width_color)
				
			if x > left_b && x < right_b:
				#color = color.blend(comb_color)
				place_tile = false
				#if width > min_width * 2:
					#if xn > left_b + min_width && xn < right_b - min_width:
						#color = Color.BLACK
				
			image.set_pixel(x, y, color)
			
			if place_tile:
				tilemap_layer.set_cell(
					bot_left_coordinates + Vector2(x, -y),
					0,
					Vector2(3, 2),
					0
				)
				
	tilemap_layer.update_internals()

	#image.unlock()

	# If it's the first time, or if you want to upload the whole image
	var texture := ImageTexture.create_from_image(image)
	($"../Sprite2D" as Sprite2D).texture = texture


func curve(x : float) -> float:
	return 1.0 - pow(abs(2.0 * x - 1.0), 10)
