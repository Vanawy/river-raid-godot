extends AnimatableBody2D
class_name Enemy

@export var hp : int = 1

signal destroyed

func damage() -> void:
	hp -= 1
	if hp < 1:
		_destroy()
			
func _destroy() -> void:
	destroyed.emit()
	queue_free()
