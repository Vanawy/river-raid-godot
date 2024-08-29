extends Area2D
class_name Rocket

@export var speed: float = 100

@onready var smoke: GPUParticles2D = $Smoke
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var explosion: AnimatedSprite2D = $Explosion
@onready var collider: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var visibility_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
	visibility_notifier.screen_exited.connect(destroy)
	body_entered.connect(hit)


func _physics_process(delta: float) -> void:
	move_local_x(speed * delta)
	
func destroy() -> void:
	collider.set_deferred("disabled", true)
	speed = 0
	smoke.emitting = false
	sprite.visible = false
	explosion.visible = true
	explosion.play()
	await get_tree().create_timer(2).timeout
	queue_free()

func hit(body : Node2D) -> void:
	#if body is Level:
		#destroy()
	if body is Enemy:
		var enemy: Enemy = body
		enemy.damage()
		
	if body is EnemyJet:
		var enemy: EnemyJet = body
		if enemy.is_dead:
			return
		enemy.damage()
		
	destroy()
