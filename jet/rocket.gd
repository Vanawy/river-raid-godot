extends AnimatedSprite2D
class_name Rocket


var velocity = Vector2(0, -100)

# Called when the node enters the scene tree for the first time.
func _ready():
	var visibility_notifier = $VisibleOnScreenNotifier2D as VisibleOnScreenNotifier2D
	visibility_notifier.screen_exited.connect(destroy)
	
	var hitbox = $Hitbox as Area2D
	hitbox.body_entered.connect(hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	position += velocity * delta
	
func destroy():
	queue_free()

func hit(body : Node2D):
	destroy()
	#if body is Level:
		#destroy()
	if body is Enemy:
		body.damage()
