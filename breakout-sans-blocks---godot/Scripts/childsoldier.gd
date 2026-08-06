class_name ChildSoldier extends Enemy


func _ready() -> void:
	hurtAudios = [$Childsoldierhurt]
	hp = 1
	dmg = 3
	tier = 1
	dropChance = 25
	shoots = true
	sprites = [$RightArm,$LeftArm,$Body]
	mainSprite = sprites[2]
	enterValue = 10
	xSpeed = 400
	ySpeed = 0
	projectilesource = preload("res://Objects/Lolly.tscn")
	
	fromLorCorR = 1
	if randi_range(0,1):
		fromLorCorR *= -1
	fromYvalue = -540/(2*RuleManager.zoom) + randi_range(10, 120)
	var x = fromLorCorR * (960/(2*RuleManager.zoom) + 60)
	var y = fromYvalue
	position = Vector2(x,y)
	xSpeed *= -fromLorCorR
	
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super(delta)
	if hp > 0:
		if abs(position.x) > (960/(2*RuleManager.zoom)) + 100 and entered:
			entered = false
			if randi_range(0,1):
				fromLorCorR *= -1
			fromYvalue = -540/(2*RuleManager.zoom) + randi_range(10, 120)
			var x = fromLorCorR * (960/(2*RuleManager.zoom) + 60)
			var y = fromYvalue
			position = Vector2(x,y)
			
			xSpeed = -fromLorCorR * 400
			#$AggressiveAnimal.play()
		xSpeed += fromLorCorR * 800 * delta
		#ySpeed += 200 * delta
	else:
		ySpeed += 400 * delta
		if position.y > 540/(2*RuleManager.zoom) + 100:
			Death()
	position += Vector2(xSpeed, ySpeed) * delta



func _on_area_entered(area: Area2D) -> void:
	super(area)
	if area == Ball and mainSprite.animation != "death":
		if hp <= 0:
			mainSprite.play("death")
			for i in range(1,len(sprites)):
				sprites[i].queue_free()
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
	var xSpeedOldOld = xSpeed
	var ySpeedOldOld = ySpeed
	super()
	xSpeed = xSpeedOldOld
	ySpeed = ySpeedOldOld
	#if mainSprite.animation == "bite":
		#mainSprite.play("idle")

func shootProjectile()->void:
	projectileSpeed = 50
	super()
