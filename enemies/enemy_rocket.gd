extends AnimatableBody2D
class_name EnemyRocket

const MAX_SPEED: float = 140

@export var speed: float = 30
@export var target: Jet = null

var is_confused: bool = false
var target_rotation: float = rotation

@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var explosion: AnimatedSprite2D = $Explosion
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var smoke_emitter: GPUParticles2D = $Smoke

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var visibility_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D 
	visibility_notifier.screen_exited.connect(destroy)

func _process(_delta: float) -> void:
	queue_redraw()

func _physics_process(delta: float) -> void:
	if speed == 0:
		return
		
	#position += velocity * delta
	speed = lerpf(speed, MAX_SPEED, delta)
	if (abs(target_rotation - rotation) > 0.1):
		rotation = lerp(rotation, target_rotation, delta)
	move_local_x(speed * delta)
	var col := move_and_collide(Vector2.ZERO)
	if col and col.get_collider() is Level:
		destroy()
	
	if target and not is_confused:
		target_rotation = rotation + get_angle_to(target.global_position)
		
		if target.is_dead:
			confuse()
	
func confuse() -> void:
	is_confused = true
	target = null
	target_rotation += [-PI/2, PI/2].pick_random()
	
	
func destroy() -> void:
	speed = 0
	hitbox.disabled = false
	smoke_emitter.emitting = false
	sprite.visible = false
	explosion.visible = true
	explosion.play()
	
	await explosion.animation_finished
	await get_tree().create_timer(2).timeout
	queue_free.call_deferred()
	
func set_target(new_target : Node2D) -> void:
	target = new_target
	
func _draw() -> void:
	if !target:
		return
	draw_line(to_local(global_position), to_local(target.global_position), Color.RED)
	draw_circle(to_local(target.global_position), 8, Color.RED)
	
	draw_line(Vector2(0, 0), Vector2(1000, 0).rotated(target_rotation - rotation), Color.REBECCA_PURPLE, 1)
