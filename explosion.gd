extends AnimatedSprite2D

func _ready() -> void:
	var timer: Timer = $Timer
	timer.start(randf() * 0.5)
	timer.timeout.connect(func() -> void:
		self.play()
	)
	animation_finished.connect(func() -> void:
		queue_free()
	)
