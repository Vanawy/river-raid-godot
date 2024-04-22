extends AnimatableBody2D
class_name Jet

enum States {
	FULL_LEFT,
	LEFT,
	FORWARD,
	RIGHT,
	FULL_RIGHT,
}

var H_SPEED: float = 70

var BASE_V_SPEED: float = 70
var V_SPEED_CHANGE: float = 100

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var smoke_emitter : GPUParticles2D = $Smoke
@onready var flares : GPUParticles2D = $Flares

@onready var rocket_scn: PackedScene = preload("res://jet/rocket.tscn")


var velocity: Vector2 = Vector2.ZERO
var state : States = States.FORWARD

var is_dead: bool = false

@export var _flares_count: int = 3

func _ready() -> void: 
	var hitbox : Area2D = $Hitbox
	hitbox.body_entered.connect(on_collision)
	var countermeasures_area : Area2D = $CounterMeasuresArea
	countermeasures_area.body_entered.connect(func(body: Node2D) -> void:
		if body is EnemyRocket:
			launch_flares(body)
	)
	

func on_collision(body : Node2D) -> void:
	if body is EnemyRocket:
		var enemy_rocket: EnemyRocket = body
		if not enemy_rocket.is_confused:
			death()
			enemy_rocket.destroy()
	if body is Level:
		death()
	if body is Enemy:
		death()

func _process(_delta: float) -> void:
	if is_dead:
		return
		
	update_state()
	if Input.is_action_just_pressed("player_fire"):
		fire()
		
func fire() -> void:
	var new_rocket: Rocket = rocket_scn.instantiate()
	add_sibling.call_deferred(new_rocket)
	new_rocket.speed += -velocity.y
	new_rocket.global_position = global_position
	new_rocket.global_rotation = -PI/2
	
func update_state() -> void:
	var hspeed: float = abs(velocity.x)
	if hspeed > 24:
		state = States.FULL_LEFT if velocity.x < 0 else States.FULL_RIGHT 
	elif hspeed > 2:
		state = States.LEFT if velocity.x < 0 else States.RIGHT 
	else:
		state = States.FORWARD
	
	sprite.frame = state

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	var move: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity.x = lerpf(velocity.x, H_SPEED * move.x, delta * 3)
	velocity.y = lerpf(velocity.y, -BASE_V_SPEED + move.y * V_SPEED_CHANGE, delta * 5)
	smoke_emitter.amount_ratio = 1 + move.y * 0.3
	
	position += velocity * delta
	
	
func death() -> void:
	is_dead = true
	velocity = Vector2.ZERO
	create_explosion()
	smoke_emitter.emitting = false
	sprite.visible = false

@onready var explosion_scenes: Array[PackedScene] = [
	preload("res://jet/explosion_top.tscn"),
	preload("res://jet/explosion_left.tscn"),
	preload("res://jet/explosion_right.tscn"),
]

func launch_flares(rocket: EnemyRocket) -> void:
		if rocket.is_confused:
			return
		if _flares_count < 1:
			print("no flares left")
			return
		flares.restart()
		_flares_count -= 1
		await get_tree().create_timer(0.1).timeout
		if (is_instance_valid(rocket)):
			rocket.confuse()

func create_explosion() -> void:
	var n: int = 0
	if state > States.FORWARD:
		n = 2
	elif state < States.FORWARD:
		n = 1
	var explosion: Node2D = explosion_scenes[n].instantiate()
	add_child.call_deferred(explosion)
