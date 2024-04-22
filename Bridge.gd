extends Node2D

@onready var bridgeEntity: Enemy = $Bridge

@onready var vehiclesLine: GPUParticles2D = $Vehicles
@onready var vehiclesLine2: GPUParticles2D = $Vehicles2

@onready var spriteOk: Sprite2D = $Bridge/Ok
@onready var spriteDestroyed: Sprite2D = $Sunk

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spriteDestroyed.visible = false
	@warning_ignore("unsafe_method_access")
	bridgeEntity.destroyed.connect(destroy)

func destroy() -> void:
	vehiclesLine.emitting = false
	vehiclesLine.visible = false
	vehiclesLine2.emitting = false
	vehiclesLine2.visible = false
	spriteOk.visible = false
	spriteDestroyed.visible = true