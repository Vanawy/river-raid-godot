extends AnimatableBody2D
class_name EnemyJet


var BASE_V_SPEED: float = 70
var V_SPEED_CHANGE: float = 32


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


var velocity: Vector2 = Vector2.ZERO

var is_dead: bool = false

# @export var _flares_count = 1

func _ready() -> void: 
	var hitbox : Area2D = $Hitbox
	hitbox.body_entered.connect(on_collision)
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

func _process(_delta: float) -> void:
	if is_dead:
		return 
		
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
	if is_dead:
		return
		
	var z: float  = 0
	
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
	velocity = Vector2.ZERO
	create_explosion()
	smoke_emitter.emitting = false
	sprite.play("explosion")
	var hitbox: Area2D = $Hitbox
	hitbox.body_entered.disconnect(on_collision)

# func launch_flares(rocket: Node2D):
# 	if rocket.is_confused:
# 		return
# 	if _flares_count < 1:
# 		print("no flares left")
# 		return
# 	flares.restart()
# 	_flares_count -= 1
# 	await get_tree().create_timer(0.1).timeout
# 	if (is_instance_valid(rocket)):
# 		rocket.confuse()

func create_explosion() -> void:
	pass


func _draw() -> void:
	# var size: float = 1000
	# draw_line(Vector2(-size, 0), Vector2(size, 0), Color.RED, 2);
	# draw_line(Vector2(0, -size), Vector2(0, size), Color.RED, 2);
	pass