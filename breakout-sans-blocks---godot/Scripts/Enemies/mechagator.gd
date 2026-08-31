class_name MechaGator extends Gator

var flyDir:float = 0.0
var sine:float= randf()*2*PI

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
	xSpeed = 100 * sign(xSpeed)
	ySpeed = 0
	projectilesource = preload("res://Objects/Projectiles/MechaPart.tscn")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	flyDir = (sin(sine)-0.5) * 25
	sine += delta * 2
	if hp > 0:
		ySpeed = flyDir
	else:
		xSpeed += 200 * delta * sign(scale.x)
		ySpeed -= 200 * delta
	super(delta)

func reenter()->void:
	if abs(position.x) > (960/(2*RuleManager.zoom)) + 100 and entered:
		launches -= 1
		sine = randf()*2*PI
	super()

func _on_area_entered(area: Area2D) -> void:
	if area == Ball and mainSprite.animation != "death":
		if area.position.y < position.y:
			ballFromTop()
		else:
			ballFromBottom()
		if hp <= 0:
			mainSprite.play("death")
			create_tween().tween_property(self,"rotation",sign(scale.x)*PI/2,4.0)
		else:
			if launches > 4:
				for i in range(1,len(sprites)):
					sprites[i].visible = true
			mainSprite.play("hurt")

func ballFromBottom()->void:
	pass

func bite(Area2D)->void:
	pass

func shootProjectile()->void:
	if randi_range(0,4) == 0:
		super()
