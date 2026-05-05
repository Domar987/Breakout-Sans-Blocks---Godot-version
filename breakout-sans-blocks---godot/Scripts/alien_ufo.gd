class_name AlienUFO extends Enemy


var moveTimer:float = 1.0
@onready var walkAudios = [$UfoHighpitch]
var walkiter:int = 0

@onready var platform:Area2D = $/root/Ingame/Platform


var tween = create_tween().set_parallel(false)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	isRare = true
	hurtAudios = [$UfoLowpitch]
	hp = 3
	dmg = 0
	tier = 1
	dropChance = 50
	shoots = false
	sprites = [$Main]
	mainSprite = sprites[0]
	enterValue = 16
	fromLorCorR = 1
	if randi_range(0,1):
		fromLorCorR *= -1
	fromYvalue = -540/(2*RuleManager.zoom) + 8 + 4
	var x = fromLorCorR * (960/(2*RuleManager.zoom))
	var y = fromYvalue
	position = Vector2(x,y)
	xSpeed = -fromLorCorR
	ySpeed = 0.0
	
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if hp > 0:
		if abs(position.x) > 960/(2*RuleManager.zoom) + enterValue and entered:
			remove()
		if mainSprite.animation == "idle":
			moveTimer -= delta
			if moveTimer <= 0:
				#walkAudios[walkiter%2].play()
				walkiter += 1
				moveTimer = 1.0
				position.x += xSpeed * 16
		super(delta)


func _on_area_entered(area: Area2D) -> void:
	super(area)
	if mainSprite.animation != "death":
		if area == Ball:
			if hp <= 0:
				mainSprite.play("death")
			else:
				for i in range(len(sprites)):
					mainSprite.play("hurt")

func getHurt()->void:
	super()
	tween.kill()
	tween = create_tween().set_parallel(false)
	tween.tween_property($UfoHighpitch,"playing",false,0.0)
	tween.tween_interval(2.30)
	tween.tween_property($UfoHighpitch,"playing",hp>0,0.0)
