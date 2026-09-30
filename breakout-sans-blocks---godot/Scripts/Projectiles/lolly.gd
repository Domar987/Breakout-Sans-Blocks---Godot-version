class_name Lolly extends Projectile

var timer:float = 0.0
var bounces:int = 0
var cheevod:bool = false
@onready var CheevoHandler = $/root/Ingame/UI/BottomRight/CheevoHandler

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	point = 40


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#print(timer)
	timer -= delta
	speed += gravity * delta
	super(delta)

func _on_area_entered(area: Area2D) -> void:
	if timer <= 0:
		super(area)
	cheevo()


func balltouched()->void:
	bounces += 1
	speed = -250.0
	ball.velocity.y = min(-88.5,ball.velocity.y)
	timer = 0.5
	RuleManager.points += pointCalculation()
	#sprite.play("blast")

func plattouched()->void:
	bounces += 1
	speed = -250.0
	RuleManager.health -= damage
	timer = 0.5
	#sprite.play("blast")

func pointCalculation()->int:
	return pointBase() * (bounces + 1)

func cheevo()->void:
	if bounces >= 3 and not cheevod:
		cheevod = true
		CheevoHandler.unlockCheevo(0)
