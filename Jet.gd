extends CharacterBody2D


enum Frames {
	FULL_LEFT,
	LEFT,
	FORWARD,
	RIGHT,
	FULL_RIGHT,
}

var H_SPEED = 48

var BASE_V_SPEED = 80
var V_SPEED_CHANGE = 32

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var smoke_emitter : GPUParticles2D = $Smoke

func _process(delta):
	update_sprite_frame()
	
func update_sprite_frame():
	var hspeed = abs(velocity.x)
	if hspeed > 24:
		sprite.frame = Frames.FULL_LEFT if velocity.x < 0 else Frames.FULL_RIGHT 
	elif hspeed > 2:
		sprite.frame = Frames.LEFT if velocity.x < 0 else Frames.RIGHT 
	else:
		sprite.frame = Frames.FORWARD
		

func _physics_process(delta):
	
	var move = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity.x = lerpf(velocity.x, H_SPEED * move.x, delta * 3)
	velocity.y = lerpf(velocity.y, -BASE_V_SPEED + move.y * V_SPEED_CHANGE, delta * 5)
	smoke_emitter.amount_ratio = 1 + move.y * 0.3
	
	move_and_slide()
	
	
