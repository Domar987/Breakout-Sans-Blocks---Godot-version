class_name ChildSoldier extends Enemy

var canAttack:bool = true

enum HandStatus{EMPTY,LEFT,RIGHT,BOTH}
var handStatus:HandStatus

var thrown:bool = false

var nonjitterPosition:Vector2

func _ready() -> void:	
	hurtAudios = [$Childsoldierhurt]
	sprites = [$Body,$LeftArm,$RightArm]
	
	attacktimer = 1837837
	
	hp = 1
	dmg = 3
	tier = 1
	dropChance = 25
	shoots = true
	mainSprite = sprites[0]
	enterValue = 10
	ySpeed = 0
	
	fromLorCorR = 1
	enter()
	
	
	projectilesource = preload("res://Objects/Lolly.tscn")
	
	position = nonjitterPosition
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super(delta)
	if hp > 0:
		throwLolly()
		
		if abs(nonjitterPosition.x) > (960/(2*RuleManager.zoom)) + 100 and entered:
			entered = false
			enter()
			
			canAttack = true
			#$AggressiveAnimal.play()
		if mainSprite.animation == "idle":
			xSpeed += fromLorCorR * 400 * delta
		else:
			xSpeed -= fromLorCorR * 5 * delta
		#print(xSpeed)
		attack()
		#ySpeed += 200 * delta
	else:
		ySpeed += 400 * delta
		if nonjitterPosition.y > 540/(2*RuleManager.zoom) + 500:
			Death()
	nonjitterPosition += Vector2(xSpeed, ySpeed) * delta
	position = nonjitterPosition + Vector2(randf()-0.5,randf()-0.5)/2.5

func enter()->void:
	if randi_range(0,1):
		fromLorCorR *= -1
	fromYvalue = -540/(2*RuleManager.zoom) + randi_range(10, 120)
	var x = fromLorCorR * (960/(2*RuleManager.zoom) + 60)
	var y = fromYvalue
	nonjitterPosition = Vector2(x,y)
	xSpeed = -fromLorCorR * randi_range(300,500)
	
	handStatus = randi_range(1,2)
	print(handStatus)
	handAnimset()

func handAnimset()->void:
	sprites[1].animation = "idleEmpty"
	sprites[2].animation = "idleEmpty"
	if handStatus == HandStatus.RIGHT:
		sprites[2].animation = "idleFull"
	elif handStatus == HandStatus.LEFT:
		sprites[1].animation = "idleFull"

func attack()->void:
	if fromLorCorR * xSpeed > 0 and canAttack:
		canAttack = false
		mainSprite.play("throw")
		for i in range(1,len(sprites)):
			sprites[i].visible = false
		
		projectilePosition = position + Vector2(8 * (handStatus * -2 + 3), 8)
		if handStatus == HandStatus.RIGHT:
			mainSprite.flip_h = true

func throwLolly()->void:
	if mainSprite.animation == "throw" and mainSprite.frame>=8 and not thrown:
		thrown = true
		attacktimer = 0
		if handStatus == HandStatus.BOTH:
			handStatus -= 1
		else:
			handStatus = HandStatus.EMPTY

func _on_area_entered(area: Area2D) -> void:
	super(area)
	if area == Ball and mainSprite.animation != "death":
		if hp <= 0:
			mainSprite.play("death")
			for i in range(len(sprites)):
				sprites[i].visible = true
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
		if mainSprite.animation == "throw":
			thrown = false
			mainSprite.flip_h = false
		xSpeed = xSpeedOld
		ySpeed = ySpeedOld
		mainSprite.play("idle")
		for i in range(len(sprites)):
			sprites[i].visible = true
		handAnimset()

func shootProjectile()->void:
	projectileSpeed = 0
	super()
