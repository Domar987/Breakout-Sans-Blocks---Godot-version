class_name ChildSoldier extends Enemy

var canAttack:bool = true

enum HandStatus{EMPTY,LEFT,RIGHT,BOTH}
var handStatus:HandStatus

var nonjitterPosition:Vector2

func _ready() -> void:
	attacktimer = 1837837
	hurtAudios = [$Childsoldierhurt]
	hp = 1
	dmg = 3
	tier = 1
	dropChance = 25
	shoots = true
	sprites = [$Body,$LeftArm,$RightArm]
	mainSprite = sprites[0]
	enterValue = 10
	xSpeed = randi_range(400,750)
	ySpeed = 0
	projectilesource = preload("res://Objects/Lolly.tscn")
	
	fromLorCorR = 1
	if randi_range(0,1):
		fromLorCorR *= -1
	fromYvalue = -540/(2*RuleManager.zoom) + randi_range(10, 120)
	var x = fromLorCorR * (960/(2*RuleManager.zoom) + 60)
	var y = fromYvalue
	nonjitterPosition = Vector2(x,y)
	xSpeed *= -fromLorCorR
	
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super(delta)
	$Label.text = str(canAttack)
	if hp > 0:
		attacktimer = int(mainSprite.frame!=8) * 999
		if abs(nonjitterPosition.x) > (960/(2*RuleManager.zoom)) + 100 and entered:
			entered = false
			if randi_range(0,1):
				fromLorCorR *= -1
			fromYvalue = -540/(2*RuleManager.zoom) + randi_range(10, 120)
			var x = fromLorCorR * (960/(2*RuleManager.zoom) + 60)
			var y = fromYvalue
			nonjitterPosition = Vector2(x,y)
			
			xSpeed = -fromLorCorR * randi_range(400,750)
			
			canAttack = true
			#$AggressiveAnimal.play()
		if mainSprite.animation == "idle":
			xSpeed += fromLorCorR * 800 * delta
		else:
			xSpeed -= fromLorCorR * 5 * delta
		#print(xSpeed)
		if fromLorCorR * xSpeed > 0 and canAttack:
			canAttack = false
			attack()
		#ySpeed += 200 * delta
	else:
		ySpeed += 400 * delta
		if nonjitterPosition.y > 540/(2*RuleManager.zoom) + 500:
			Death()
	nonjitterPosition += Vector2(xSpeed, ySpeed) * delta
	position = nonjitterPosition + Vector2(randf()-0.5,randf()-0.5)/2.5

func attack()->void:
	if handStatus == HandStatus.RIGHT:
		mainSprite.flip_h = true
	mainSprite.play("throw")
	if handStatus == HandStatus.BOTH:
		handStatus -= 1
	else:
		handStatus = HandStatus.EMPTY

func _on_area_entered(area: Area2D) -> void:
	super(area)
	if area == Ball and mainSprite.animation != "death":
		if hp <= 0:
			mainSprite.play("death")
			if handStatus == HandStatus.LEFT or handStatus == HandStatus.BOTH:
				sprites[1].play("deadFull")
			else:
				sprites[1].play("deadEmpty")
			if handStatus == HandStatus.RIGHT or handStatus == HandStatus.BOTH:
				sprites[2].play("deadFull")
			else:
				sprites[2].play("deadEmpty")
		else:
			mainSprite.play("hurt")

func getHurt()->void:
	#hp -= RuleManager.damage
	#if hp <= 0:
		#xSpeed = 0
		#ySpeed = 0
	super()
	if hp > 0:
		xSpeed = xSpeedOld
		ySpeed = ySpeedOld

func _on_animated_sprite_2d_animation_finished() -> void:
	if mainSprite.animation != "death":
		xSpeed = xSpeedOld
		ySpeed = ySpeedOld
		for i in range(len(sprites)):
			sprites[i].play("idle")

func shootProjectile()->void:
	projectileSpeed = 0
	super()
