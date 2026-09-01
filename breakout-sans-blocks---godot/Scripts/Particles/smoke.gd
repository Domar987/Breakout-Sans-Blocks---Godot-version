class_name Smoke extends Particle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vanishwhenfinish = true
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super(delta)

func speedFormula()->void:
	speed += Vector2(-speed.x*0.1,-speed.y*0.45)
