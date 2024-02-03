extends Node2D

@onready var bridgeEntity = $Bridge as Enemy

@onready var vehiclesLine = $Vehicles as GPUParticles2D
@onready var vehiclesLine2 = $Vehicles2 as GPUParticles2D

@onready var spriteOk = $Bridge/Ok
@onready var spriteDestroyed = $Sunk

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spriteDestroyed.visible = false
	bridgeEntity.destroyed.connect(func():
		vehiclesLine.emitting = false
		vehiclesLine.visible = false
		vehiclesLine2.emitting = false
		vehiclesLine2.visible = false
		spriteOk.visible = false
		spriteDestroyed.visible = true
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
