extends AnimatableBody2D
class_name Enemy

@export var hp = 1

signal destroyed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func damage():
	hp -= 1
	if hp < 1:
		_destroy()
			
func _destroy():
	destroyed.emit()
	queue_free()
