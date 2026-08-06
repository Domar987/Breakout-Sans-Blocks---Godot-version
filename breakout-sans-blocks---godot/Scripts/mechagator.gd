class_name MechaGator extends Gator


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurtAudios = [$GatorHurt]
	hp = 4
	dmg = 1
	tier = 2
	dropChance = 40
	shoots = true
	sprites = [$Head,$Arm,$Body,$Fire]
	xSpeed = 100
	ySpeed = 0
	projectilesource = preload("res://Objects/GatorTooth.tscn")
	
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	launches -= 1
	ySpeed = 0
	super(delta)


func ballFromBottom()->void:
	pass
