extends AnimatableBody2D
class_name EnemyRocket

const MAX_SPEED = 140

@export var speed = 30

@export var target : Jet = null

var is_confused = false

var target_rotation = rotation

# Called when the node enters the scene tree for the first time.
func _ready():
	var visibility_notifier = $VisibleOnScreenNotifier2D as VisibleOnScreenNotifier2D
	visibility_notifier.screen_exited.connect(destroy)

func _process(_delta: float) -> void:
	queue_redraw()

func _physics_process(delta):
	if speed == 0:
		return
		
	#position += velocity * delta
	speed = lerpf(speed, MAX_SPEED, delta)
	if (abs(target_rotation - rotation) > 0.1):
		rotation = lerp(rotation, target_rotation, delta)
	move_local_x(speed * delta)
	var col = move_and_collide(Vector2.ZERO) as KinematicCollision2D
	if col and col.get_collider() is Level:
		destroy()
	
	if target and not is_confused:
		target_rotation = rotation + get_angle_to(target.global_position)
		
		if target.is_dead:
			confuse()
	
func confuse():
	is_confused = true
	target = null
	target_rotation += [-PI/2, PI/2].pick_random()
	
	
func destroy():
	speed = 0
	$CollisionShape2D.set_deferred("disabled", false)
	$CollisionShape2D/Smoke.emitting = false
	$CollisionShape2D/Rocket.visible = false
	var explosion = $Explosion as AnimatedSprite2D
	explosion.visible = true
	explosion.play()
	await explosion.animation_finished
	await get_tree().create_timer(2).timeout
	queue_free()
	
func set_target(new_target : Node2D):
	target = new_target
	
func _draw() -> void:
	if !target:
		return
	draw_line(to_local(global_position), to_local(target.global_position), Color.RED)
	draw_circle(to_local(target.global_position), 8, Color.RED)
	
	draw_line(Vector2(0, 0), Vector2(1000, 0).rotated(target_rotation - rotation), Color.REBECCA_PURPLE, 1)
