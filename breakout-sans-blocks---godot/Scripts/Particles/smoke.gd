class_name Smoke extends Particle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = Vector2(randf_range(-40,40),randf_range(-60,30))
	vanishwhenfinish = true
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super(delta)

func speedFormula(delta)->void:
	speed += Vector2(-speed.x*0.1,-300/speed.y) * delta
