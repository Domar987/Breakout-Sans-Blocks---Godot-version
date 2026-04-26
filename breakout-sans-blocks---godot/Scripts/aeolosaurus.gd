extends Enemy


var speedTween:Tween
var sineTimer:float = 0
var dealtDamage:bool = false
@onready var platform:Area2D = $/root/Ingame/Platform
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp = 10
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
	
	super()

func _on_area_entered(area: Area2D) -> void:
	super(area)
	if mainSprite.animation != "death":
		if area == Ball:
			if hp <= 0:
				mainSprite.play("death")
				speedTween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN).set_parallel(true)
				speedTween.tween_property(self,"xSpeed",3.5,2.5)
				speedTween.tween_property(self,"ySpeed",2,4)
			else:
				for i in range(len(sprites)):
					mainSprite.play("hurt")
					sprites[2].pause()
					sineTimer = 0
		elif area == platform and position.y < area.position.y and not dealtDamage:
			RuleManager.health -= dmg
			dealtDamage = true

func ballFromBottom()->void:
	hp -= RuleManager.damage
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if hp > 0:
		if mainSprite.animation == "idle":
			sineTimer += 25 * delta
			xSpeed = sin(deg_to_rad(sineTimer)) / 10
			if randi_range(0, 10) == 2:
				if ySpeed > 0.2:
					ySpeed += randf_range(-0.015, 0.01)
				else:
					ySpeed += randf_range(0, 0.01)
		super(delta)
	else:
		pass
	position += Vector2(xSpeed, ySpeed * (1 + RuleManager.difficulty/5))
	for i in range(-1, len(sprites)-1):
		sprites[i].position = Vector2(1.25*i*signf(xSpeed)*sqrt(abs(xSpeed)),1.25*i*signf(ySpeed)*sqrt(abs(ySpeed)))
