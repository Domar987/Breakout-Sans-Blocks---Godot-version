extends Enemy

var speedTween:Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp = 6
	dmg = 6
	shoots = false
	sprites = [$Head,$Body,$Tail]
	mainSprite = sprites[0]
	enterValue = 0
	xSpeed = 0
	ySpeed = 0.1
	fromLorCorR = 0
	fromYvalue = -540/(2*RuleManager.zoom) - 32
	var x = randi_range(-960/(2*RuleManager.zoom) + 60,960/(2*RuleManager.zoom) - 60)
	var y = fromYvalue
	position = Vector2(x,y)
	speedTween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	super()

func _on_area_entered(area: Area2D) -> void:
	if area == Ball and mainSprite.animation != "death":
		hp -= 1
		xSpeedOld = xSpeed
		xSpeed = 0
		ySpeedOld = ySpeed
		ySpeed = 0
		if hp <= 0:
			mainSprite.play("death")
		else:
			for i in range(len(sprites)):
				mainSprite.play("hurt")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if hp > 0:
		super(delta)
		position += Vector2(xSpeed, ySpeed * (1 + RuleManager.difficulty/5))
	else:
		speedTween.tween_property(self,"xSpeed",10,2.0)
		speedTween.tween_property(self,"ySpeed",0.075,1.5)
