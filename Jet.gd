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
var V_SPEED_CHANGE: float = 40

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var smoke_emitter : GPUParticles2D = $Smoke
@onready var flares_emitter : GPUParticles2D = $Flares

@onready var rockets: ReloadIndicators = $Indicators/Rockets
@onready var flares: ReloadIndicators = $Indicators/Flares

@onready var rocket_scn: PackedScene = preload("res://jet/rocket.tscn")

@onready var countermeasures_area : Area2D = $CounterMeasuresArea
@onready var countermeasures_effect_area : Area2D = $CounterMeasuresEffectArea

var velocity: Vector2 = Vector2.ZERO
var state : States = States.FORWARD

var is_dead: bool = false

var input_horizontal: float = 0



signal died

func _ready() -> void: 
	var hitbox : Area2D = $Hitbox
	hitbox.body_entered.connect(on_collision)
	#countermeasures_area.body_entered.connect(func(body: Node2D) -> void:
		#if body is EnemyRocket:
			#launch_flares(body)
	#)
	

func on_collision(body : Node2D) -> void:
	if body is EnemyRocket:
		var enemy_rocket: EnemyRocket = body
		if not enemy_rocket.is_confused:
			death()
			enemy_rocket.destroy()
	if body.is_in_group("LEVEL"):
		death()
	if body is Enemy:
		var enemy: Enemy = body
		enemy.damage()
		death()

func _process(_delta: float) -> void:
	if is_dead:
		return
		
	update_state()
	if Input.is_action_just_pressed("player_fire"):
		fire()
	
	_check_flares()
	
func _check_flares() -> void:
	var is_flares_launched: bool = false
	if countermeasures_area.has_overlapping_bodies():
		for body in countermeasures_effect_area.get_overlapping_bodies():
			if body is EnemyRocket:
				if body.is_confused:
					continue
				if not is_flares_launched:
					if launch_flares():
						is_flares_launched = true
				if is_flares_launched:
					if is_instance_valid(body) and !body.is_confused:
						body.confuse()
		
		
func fire() -> void:
	if !rockets.fire():
		return
	var new_rocket: Rocket = rocket_scn.instantiate()
	add_sibling.call_deferred(new_rocket)
	new_rocket.speed += -velocity.y
	new_rocket.global_position = global_position
	new_rocket.global_rotation = -PI/2
	
func update_state() -> void:
	var hspeed: float = abs(velocity.x)
	if hspeed > 24 or (hspeed > 12 and abs(input_horizontal) > 0):
		state = States.FULL_LEFT if velocity.x < 0 else States.FULL_RIGHT 
	elif hspeed > 2:
		state = States.LEFT if velocity.x < 0 else States.RIGHT 
	else:
		state = States.FORWARD
	
	sprite.frame = state

func _physics_process(delta: float) -> void:

	var move := Vector2.ZERO
	if !is_dead:
		move = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		input_horizontal = move.x
		velocity.x = lerpf(velocity.x, H_SPEED * move.x, delta * 3)
		velocity.y = lerpf(velocity.y, -BASE_V_SPEED + move.y * V_SPEED_CHANGE, delta * 5)
	else:
		velocity.y = lerpf(velocity.y, 0, delta)
	
	smoke_emitter.amount_ratio = 1 + move.y * 0.3
	
	position += velocity * delta
	
	
func death() -> void:
	if is_dead:
		return
	is_dead = true
	died.emit()
	
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	$Indicators.visible = false
	
	# velocity = Vector2.ZERO
	# create_explosion()
	sprite.self_modulate = Color.hex(0x292929ff)
	var tween: Tween = create_tween()
	await tween.tween_property(sprite, "scale", Vector2(0.5, 0.5), 0.6).set_trans(Tween.TRANS_LINEAR).finished
	sprite.scale = Vector2(1, 1)
	sprite.self_modulate = Color.WHITE
	velocity = Vector2.ZERO
	sprite.play("explosion")
	smoke_emitter.emitting = false
	await sprite.animation_finished
	sprite.visible = false

@onready var explosion_scenes: Array[PackedScene] = [
	preload("res://jet/explosion_top.tscn"),
	preload("res://jet/explosion_left.tscn"),
	preload("res://jet/explosion_right.tscn"),
]

func launch_flares() -> bool:
		if !flares.fire():
			return false
		flares_emitter.restart()
		return true

func create_explosion() -> void:
	var n: int = 0
	if state > States.FORWARD:
		n = 2
	elif state < States.FORWARD:
		n = 1
	var explosion: Node2D = explosion_scenes[n].instantiate()
	add_child.call_deferred(explosion)

func refuel(amount: float) -> void:
	pass
