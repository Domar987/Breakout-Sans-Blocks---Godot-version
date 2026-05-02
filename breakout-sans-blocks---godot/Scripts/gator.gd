class_name Gator extends Enemy

var launches:int = 1

func _ready() -> void:
	hurtAudios = [$GatorHurt]
	hp = 4
	dmg = 5
	shoots = false
	sprites = [$Head,$Arm,$Body]
	mainSprite = sprites[0]
	enterValue = 10
	xSpeed = 400
	ySpeed = -150
	projectilesource = preload("res://Objects/GatorTooth.tscn")
	
	fromLorCorR = 1
	if randi_range(0,1):
		fromLorCorR *= -1
	fromYvalue = -540/(2*RuleManager.zoom) + randi_range(60, 160)
	var x = fromLorCorR * (960/(2*RuleManager.zoom) + 60)
	var y = fromYvalue
	position = Vector2(x,y)
	xSpeed *= -fromLorCorR
	scale.x *= signf(xSpeed)
	
	$BiteArea.area_entered.connect(bite)
	
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super(delta)
	if hp > 0:
		if launches > 4 and mainSprite.animation == "idle":
			mainSprite.play("content")
			for i in range(1,len(sprites)):
				sprites[i].visible = false
		if abs(position.x) > (960/(2*RuleManager.zoom)) + 100 and entered:
			if launches > 4:
				remove()
			entered = false
			xSpeed *= -1
			ySpeed = -180
			scale.x *= -1
			$AggressiveAnimal.play()
			position.y = -540/(2*RuleManager.zoom) + randi_range(60, 160)
			launches += 1
		ySpeed += 200 * delta
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
			if launches > 4:
				for i in range(1,len(sprites)):
					sprites[i].visible = true
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

func bite(area:Area2D)->void:
	if hp > 0 and launches <= 4 and area is Enemy and not(area is Gator or area is Aeolo):
		mainSprite.stop()
		sprites[1].stop()
		mainSprite.play("bite")
		sprites[1].play("bite")
		projectilePosition = area.position
		shootProjectile()
		area.remove()
		var audio = area.hurtAudios.pick_random()
		audio.pitch_scale = randf_range(0.9,1.0)
		audio.play()
		$GatorChomp.pitch_scale = randf_range(0.25,0.75)
		$GatorChomp.play()

func ballFromBottom()->void:
	hp -= RuleManager.damage
	super()

func _on_animated_sprite_2d_animation_finished() -> void:
	var xSpeedOldOld = xSpeed
	var ySpeedOldOld = ySpeed
	super()
	xSpeed = xSpeedOldOld
	ySpeed = ySpeedOldOld
	if launches > 4 and hp > 0:
		for i in range(1,len(sprites)):
			sprites[i].visible = false
		mainSprite.play("content")
	#if mainSprite.animation == "bite":
		#mainSprite.play("idle")

func shootProjectile()->void:
	projectileSpeed = -200
	super()
