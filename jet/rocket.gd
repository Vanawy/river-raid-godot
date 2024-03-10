extends Area2D
class_name Rocket

var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	var visibility_notifier = $VisibleOnScreenNotifier2D as VisibleOnScreenNotifier2D
	visibility_notifier.screen_exited.connect(destroy)
	body_entered.connect(hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	move_local_x(speed * delta)
	
func destroy():
	speed = 0
	$Smoke.emitting = false
	$Rocket.visible = false
	var explosion = $Explosion as AnimatedSprite2D
	explosion.visible = true
	explosion.play()
	await get_tree().create_timer(2).timeout
	queue_free()

func hit(body : Node2D):
	#if body is Level:
		#destroy()
	if body is Enemy:
		body.damage()
		
	if body is EnemyJet:
		if (body as EnemyJet).is_dead:
			return
		body.damage()
		
	destroy()
