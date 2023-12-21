extends AnimatableBody2D
class_name Enemy

@export var hp = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func damage():
	hp -= 1
	if hp < 1:
		_destroy()
			
func _destroy():
	queue_free()
