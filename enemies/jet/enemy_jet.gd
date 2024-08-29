extends AnimatableBody2D
class_name EnemyJet


var H_SPEED: float = 70
@export var BASE_V_SPEED: float = 70
var V_SPEED_CHANGE: float = 32

var move_direction: float = 0;

var time: float = randf() * 10;


enum States {
	FULL_LEFT,
	LEFT,
	FORWARD,
	RIGHT,
	FULL_RIGHT,
}

var state : States = States.FORWARD

var hp: int = 1

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var smoke_emitter : GPUParticles2D = $Smoke
# @onready var flares : GPUParticles2D = $Flares

@onready var rockets_collider: CollisionShape2D = $RocketsCollision


var velocity: Vector2 = Vector2.ZERO

var is_dead: bool = false

signal destroyed

# @export var _flares_count = 1

func _ready() -> void: 
	var hitbox : Area2D = $Hitbox
	hitbox.body_entered.connect(on_collision)
	sprite.play("default")
	
	# var countermeasures_area : Area2D = $CounterMeasuresArea
	# countermeasures_area.body_entered.connect(func(body: Node2D):
	# 	if body is EnemyRocket:
	# 		launch_flares(body)
	# )

func on_collision(body : Node2D) -> void:
	if body is Jet:
		death()
		var jet: Jet = body
		jet.death()
	if body is EnemyRocket:
		print_rich("[color=red][b]HIT[/b][/color]")
		death()
		var rocket: EnemyRocket = body
		rocket.destroy()

func _process(delta: float) -> void:
	time += delta
	if !is_dead:
		update_state()

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
		
	var z: float  = 0
	
	H_SPEED = sin(time / 2) * 3
	#print(H_SPEED)
	
	if !is_dead:
		velocity.x = lerpf(velocity.x, H_SPEED, delta * 3)
		velocity.y = lerpf(velocity.y, -BASE_V_SPEED + z * V_SPEED_CHANGE, delta * 5)

	smoke_emitter.amount_ratio = 1 + z * 0.3
	
	position += transform.basis_xform(velocity * delta)
	#position += velocity * delta
	
func damage() -> void:
	if is_dead:
		return
	hp -= 1
	if hp < 1:
		death()
	
func death() -> void:
	is_dead = true
	destroyed.emit()
	# velocity = Vector2.ZERO
	smoke_emitter.emitting = false
	var hitbox: Area2D = $Hitbox
	hitbox.body_entered.disconnect(on_collision)
	rockets_collider.queue_free()

	sprite.modulate = Color.hex(0x292929ff)
	var tween: Tween = create_tween()
	await tween.tween_property(sprite, "scale", Vector2(0.5, 0.5), 0.3).set_trans(Tween.TRANS_LINEAR).finished
	sprite.scale = Vector2(1, 1)
	sprite.modulate = Color.WHITE
	velocity = Vector2.ZERO
	sprite.play("explosion")
	await sprite.animation_finished
	queue_free()



func _draw() -> void:
	#var size: float = 10000
	#draw_line(Vector2(-size, 0), Vector2(size, 0), Color.RED, 2);
	#draw_line(Vector2(0, -size), Vector2(0, size), Color.RED, 2);
	pass
