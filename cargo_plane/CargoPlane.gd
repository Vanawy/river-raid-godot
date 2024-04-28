extends AnimatableBody2D


var BASE_V_SPEED: float = 70

var velocity: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2(0, -BASE_V_SPEED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta)
