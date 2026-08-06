class_name Lolly extends Projectile

var timer:float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if timer > 0:
		timer -= delta
	speed += gravity * delta
	super(delta)

func _on_area_entered(area: Area2D) -> void:
	if timer <= 0:
		super(area)
		timer = 1.0


func balltouched()->void:
	speed = -10.0
	ball.velocity.y = min(-88.5,ball.velocity.y)
	#sprite.play("blast")

func plattouched()->void:
	speed = -10.0
	RuleManager.health -= damage
	#sprite.play("blast")
