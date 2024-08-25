extends Enemy
class_name AABoat

@onready var aa: AALauncher = $CargoPlace/pantsir/AntiAirRocketLauncher

func set_difficulty(difficulty: float) -> void:
	aa.difficulty = difficulty
