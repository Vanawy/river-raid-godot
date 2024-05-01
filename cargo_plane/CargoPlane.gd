extends AnimatableBody2D


const BASE_V_SPEED: float = 70
const FUEL_PER_SEC = 10;

var velocity: Vector2 = Vector2.ZERO


@onready var refuel_area: Area2D = $Refuel
@onready var refuel_area_sprite: Sprite2D = $Refuel/RefuelAreaSprite
@onready var active_refuel_area_sprite: Sprite2D = $Refuel/RefuelAreaSpriteActive

var is_jet_in_area: bool = false
var jet: Jet = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2(0, -BASE_V_SPEED)
	refuel_area_sprite.visible = true
	active_refuel_area_sprite.visible = false

	refuel_area.body_entered.connect(func(body: Node2D) -> void:
		if !body is Jet:
			return
		jet = body
		refuel_area_sprite.visible = false
		active_refuel_area_sprite.visible = true
		is_jet_in_area = true
	)

	refuel_area.body_exited.connect(func(body: Node2D) -> void:
		if !body is Jet:
			return
		jet = null
		refuel_area_sprite.visible = true
		active_refuel_area_sprite.visible = false
		is_jet_in_area = false
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	position += transform.basis_xform(velocity * delta)

	if is_jet_in_area:
		jet.refuel(delta * FUEL_PER_SEC)
	
