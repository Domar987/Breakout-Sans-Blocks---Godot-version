extends Area2D

#@onready var sprite = $AnimatedSprite2D
var timer:int = 0

@export var lightcolor:Color
@export var maincolor:Color
@export var darkcolor:Color
@export var outlinelightcolor:Color
@export var outlinedarkcolor:Color

@onready var RuleManager = $/root/Ingame/RuleManager
@onready var platform = $/root/Ingame/Platform
@onready var wall = $/root/Ingame/Wall

var velocity:Vector2 = Vector2.ZERO
var ballgravity:float = 9.81
var hitcounter:int = 0

var frozen:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lightcolor = Color(RuleManager.activecolor["lightcolor"])
	maincolor = Color(RuleManager.activecolor["maincolor"])
	darkcolor = Color(RuleManager.activecolor["darkcolor"])
	outlinelightcolor = Color(RuleManager.activecolor["outlinelightcolor"])
	outlinedarkcolor = Color(RuleManager.activecolor["outlinedarkcolor"])
	$BallLight.modulate = lightcolor
	$BallMain.modulate = maincolor
	$BallMain/BallTrail.modulate = maincolor
	$BallMain/BallTrail2.modulate = maincolor
	$BallDark.modulate = darkcolor
	$BallOutlineLight.modulate = outlinelightcolor
	$BallOutlineDark.modulate = outlinedarkcolor


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if RuleManager.ballPosCheat:
		position = get_global_mouse_position()
		velocity = Vector2.ZERO
	elif not frozen:
		timer -= 1
		velocity.y += delta * gravity
		if position.x > 960/(2*RuleManager.zoom):
			if RuleManager.walls:
				position = Vector2.ZERO
				velocity = Vector2.ZERO
			else:
				$BallMain/BallTrail.drawline = not $BallMain/BallTrail.drawline
				$BallMain/BallTrail2.drawline = not $BallMain/BallTrail2.drawline
				position.x = -960/(2*RuleManager.zoom)
		elif position.x < -960/(2*RuleManager.zoom):
			if RuleManager.walls:
				position = Vector2.ZERO
				velocity = Vector2.ZERO
			else:
				$BallMain/BallTrail.drawline = not $BallMain/BallTrail.drawline
				$BallMain/BallTrail2.drawline = not $BallMain/BallTrail2.drawline
				position.x = 960/(2*RuleManager.zoom)
		if position.y > 540/(2*RuleManager.zoom) + 50 and RuleManager.health > 0:
			fall()
		#if linear_velocity.y < 10:
		#	sprite.frame = 0
		#elif linear_velocity.y < 20:
		#	sprite.frame = 1
		#elif linear_velocity.y < 40:
		#	sprite.frame = 2
		#else:
		#	sprite.frame = 3
		position += velocity * delta

func fall()->void:
	RuleManager.health -= 1
	frozen = true
	$RetrieveBall.play()
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_parallel(false)
	tween.tween_property(self,"position",Vector2.ZERO,1.5)
	tween.tween_property(self,"velocity",Vector2.ZERO,0.0)
	tween.tween_property(self,"frozen",false,0.0)

func _on_area_entered(area: Area2D) -> void:
	if area == platform:
		if position.y > area.position.y:
			pass #ek puan/para
		hitcounter += 1
		if hitcounter % 10 == 0:
			RuleManager.difficulty += 1
		#velocity.y = -(5.0 + RuleManager.difficulty)
		#velocity.y = -sqrt(2*gravity*(platform.y + 540/(2*RuleManager.zoom)))
		#velocity.x = (position.x - area.position.x) * (100.0/area.length) * (10+RuleManager.difficulty/4.0)
		velocity = get_launch(position,area.position,area.length,45)
	elif area == wall and timer <= 0:
		timer = 1
		velocity.x *= -1

func get_launch(ballpos:Vector2,platpos:Vector2,length:float,dirLimit:float)->Vector2:
	var lerpvalue = (ballpos.x-platpos.x)/(length/2)
	lerpvalue += 1
	lerpvalue /= 2
	var dir = lerpf(-dirLimit,dirLimit, lerpvalue) + 270
	var magn = sqrt(2*gravity*(platpos.y + 540/(2*RuleManager.zoom)))
	var finalVec:Vector2
	finalVec.x = magn * cos(deg_to_rad(dir))
	finalVec.y = magn * sin(deg_to_rad(dir))
	return finalVec
