class_name MechaGator extends Gator

var flyDir:float = 0.0
var sine:float= randf()*2*PI
var popAudios:Array[AudioStreamPlayer]

var shakeAmount:float=0.1

var particles:Array[PackedScene] = [load("res://Objects/Particles/SmokeMedium.tscn"),load("res://Objects/Particles/SmokeSmall.tscn")]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attacktimer = 10
	super()
	hurtAudios = [$GatorHurt]
	popAudios = [$MechaPop1,$MechaPop2,$MechaPop3,$MechaPop4,$MechaPop5]
	
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
	if shakeAmount > 0:
		sprites[0].position = Vector2(randf_range(-1,1) * shakeAmount,randf_range(-1,1) * shakeAmount)
		sprites[1].position = Vector2(randf_range(-1,1) * shakeAmount,randf_range(-1,1) * shakeAmount)
		sprites[3].position = Vector2(randf_range(-1,1) * shakeAmount,randf_range(-1,1) * shakeAmount)
	else:
		sprites[0].position = Vector2.ZERO
		sprites[1].position = Vector2.ZERO
		sprites[3].position = Vector2.ZERO
		
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
	print(name+" hit from below")
	getHurt()

func getHurt()->void:
	super()
	var tween = create_tween()
	if hp > 0:
		ParticleSystem.new().emit.call(particles,randi_range(3,5),global_position + scale * Vector2(6,-12))
		tween.tween_property(self,"shakeAmount",1.0,0.15)
		tween.tween_interval(0.2)
		tween.tween_property(self,"shakeAmount",0.1,0.25)
	else:
		ParticleSystem.new().emit.call(particles,randi_range(4,7),global_position + scale * Vector2(6,-12))
		tween.tween_property(self,"shakeAmount",2.0,0.25)

func bite(Area2D)->void:
	pass

func shootProjectile()->void:
	if randi_range(0,4) == 0:
		projectileSpeed = 1
		projectilePosition = position + scale * Vector2(-3,0)
		if randi_range(0,3) == 0:
			projectilePosition = position + scale * Vector2(6,-12)
			projectileSpeed = -1.5
		var audio = popAudios.pick_random()
		audio.pitch_scale = randf_range(0.9,1.0)
		audio.play()
		super()
