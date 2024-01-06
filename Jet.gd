extends AnimatableBody2D
class_name Jet

enum States {
	FULL_LEFT,
	LEFT,
	FORWARD,
	RIGHT,
	FULL_RIGHT,
}

var H_SPEED = 70

var BASE_V_SPEED = 70
var V_SPEED_CHANGE = 32

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var smoke_emitter : GPUParticles2D = $Smoke
@onready var flares : GPUParticles2D = $Flares

@onready var rocket_scn = preload("res://jet/rocket.tscn")


var velocity = Vector2.ZERO
var state : States = States.FORWARD

var is_dead = false

@export var _flares_count = 3

func _ready(): 
	var hitbox : Area2D = $Hitbox
	hitbox.body_entered.connect(on_collision)
	var countermeasures_area : Area2D = $CounterMeasuresArea
	countermeasures_area.body_entered.connect(func(body: Node2D):
		if body is EnemyRocket:
			launch_flares(body)
	)
	
	
	

func on_collision(body : Node2D):
	if body is EnemyRocket:
		if not body.is_confused:
			death()
			body.destroy()
	if body is Level:
		death()

func _process(delta):
	if is_dead:
		return
		
	update_state()
	if Input.is_action_just_pressed("player_fire"):
		fire()
		
func fire():
	var new_rocket = rocket_scn.instantiate() as Rocket
	add_sibling.call_deferred(new_rocket)
	new_rocket.speed += -velocity.y
	new_rocket.global_position = global_position
	new_rocket.global_rotation = -PI/2
	
func update_state():
	var hspeed = abs(velocity.x)
	if hspeed > 24:
		state = States.FULL_LEFT if velocity.x < 0 else States.FULL_RIGHT 
	elif hspeed > 2:
		state = States.LEFT if velocity.x < 0 else States.RIGHT 
	else:
		state = States.FORWARD
	
	sprite.frame = state

func _physics_process(delta):
	if is_dead:
		return
	
	var move = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity.x = lerpf(velocity.x, H_SPEED * move.x, delta * 3)
	velocity.y = lerpf(velocity.y, -BASE_V_SPEED + move.y * V_SPEED_CHANGE, delta * 5)
	smoke_emitter.amount_ratio = 1 + move.y * 0.3
	
	position += velocity * delta
	
	
func death():
	is_dead = true
	velocity = Vector2.ZERO
	create_explosion()
	$Smoke.emitting = false
	$AnimatedSprite2D.visible = false

@onready var explosion_scenes = [
	preload("res://jet/explosion_top.tscn"),
	preload("res://jet/explosion_left.tscn"),
	preload("res://jet/explosion_right.tscn"),
]

func launch_flares(rocket: Node2D):
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

func create_explosion():
	var n = 0
	if state > States.FORWARD:
		n = 2
	elif state < States.FORWARD:
		n = 1
	var explosion = explosion_scenes[n].instantiate() as Node2D
	add_child.call_deferred(explosion)
