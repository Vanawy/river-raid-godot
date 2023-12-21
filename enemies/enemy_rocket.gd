extends AnimatableBody2D
class_name EnemyRocket

const MAX_SPEED = 140

var speed = MAX_SPEED

@export var _target : Jet = null

var is_confused = false

var _target_rotation = rotation

# Called when the node enters the scene tree for the first time.
func _ready():
	var visibility_notifier = $VisibleOnScreenNotifier2D as VisibleOnScreenNotifier2D
	visibility_notifier.screen_exited.connect(destroy)

func _physics_process(delta):
	#position += velocity * delta
	rotation = lerp(rotation, _target_rotation, delta * 3)
	move_local_x(speed * delta)
	var col = move_and_collide(Vector2.ZERO) as KinematicCollision2D
	if col and col.get_collider() is Level:
		destroy()
	
	if _target and not is_confused:
		_target_rotation += get_angle_to(_target.global_position)
		
		if _target.is_dead:
			confuse()
	
func confuse():
	is_confused = true
	_target = null
	_target_rotation += [-PI/2, PI/2].pick_random()
	
	
func destroy():
	speed = 0
	$CollisionShape2D.set_deferred("disabled", false)
	$CollisionShape2D/Smoke.emitting = false
	$CollisionShape2D/Rocket.visible = false
	await get_tree().create_timer(2).timeout
	queue_free()
