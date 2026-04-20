extends Area2D

#@onready var sprite = $AnimatedSprite2D
var timer:int = 0

@export var lightcolor:Color
@export var maincolor:Color
@export var darkcolor:Color

@onready var RuleManager = $/root/Ingame/RuleManager
@onready var platform = $/root/Ingame/Platform
@onready var wall = $/root/Ingame/Wall

var velocity:Vector2 = Vector2.ZERO
var ballgravity:float = 9.81
var hitcounter:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lightcolor = Color(RuleManager.activecolor["lightcolor"])
	maincolor = Color(RuleManager.activecolor["maincolor"])
	darkcolor = Color(RuleManager.activecolor["darkcolor"])
	$BallLight.modulate = lightcolor
	$BallMain.modulate = maincolor
	$BallMain/BallTrail.modulate = maincolor
	$BallMain/BallTrail2.modulate = maincolor
	$BallDark.modulate = darkcolor


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	timer -= 1
	velocity.y += delta * ballgravity
	if position.x > get_viewport().size.x/(2*RuleManager.zoom):
		if RuleManager.walls:
			position = Vector2.ZERO
			velocity = Vector2.ZERO
		else:
			$BallMain/BallTrail.drawline = not $BallMain/BallTrail.drawline
			$BallMain/BallTrail2.drawline = not $BallMain/BallTrail2.drawline
			position.x = -get_viewport().size.x/(2*RuleManager.zoom)
	elif position.x < -get_viewport().size.x/(2*RuleManager.zoom):
		if RuleManager.walls:
			position = Vector2.ZERO
			velocity = Vector2.ZERO
		else:
			$BallMain/BallTrail.drawline = not $BallMain/BallTrail.drawline
			$BallMain/BallTrail2.drawline = not $BallMain/BallTrail2.drawline
			position.x = get_viewport().size.x/(2*RuleManager.zoom)
	#if linear_velocity.y < 10:
	#	sprite.frame = 0
	#elif linear_velocity.y < 20:
	#	sprite.frame = 1
	#elif linear_velocity.y < 40:
	#	sprite.frame = 2
	#else:
	#	sprite.frame = 3
	position += velocity


func _on_body_entered(body: Node2D) -> void:
	if body == platform:
		if position.y > body.position.y:
			pass
		hitcounter += 1
		if hitcounter % 10 == 0:
			RuleManager.difficulty += 1
		velocity.y = -(5.0 + RuleManager.difficulty)
		velocity.x = (position.x - body.position.x) * (10.0/body.length) * (1+RuleManager.difficulty/4.0)
	elif body == wall and timer <= 0:
		timer = 1
		velocity.x *= -1
