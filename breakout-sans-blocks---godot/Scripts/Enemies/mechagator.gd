class_name MechaGator extends Gator

var flyDir:float = 50#randi_range(-50, 50)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attacktimer = 10
	super()
	hurtAudios = [$GatorHurt]
	hp = 4
	dmg = 1
	tier = 2
	dropChance = 40
	shoots = true
	sprites = [$Head,$Arm,$Body,$Fire]
	xSpeed = 100
	ySpeed = 0
	projectilesource = preload("res://Objects/Projectiles/GatorTooth.tscn")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	ySpeed = flyDir
	super(delta)

func reenter()->void:
	if abs(position.x) > (960/(2*RuleManager.zoom)) + 100 and entered:
		launches -= 1
		flyDir = randi_range(-50, 50)
	super()

func ballFromBottom()->void:
	pass

func shootProjectile()->void:
	if randi_range(0,4) == 0:
		super()
