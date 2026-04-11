extends RigidBody2D

#@onready var sprite = $AnimatedSprite2D
var timer = 0
@export var lightcolor:Color
@export var maincolor:Color
@export var darkcolor:Color
@onready var RuleManager = $/root/Ingame/RuleManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lightcolor = Color(RuleManager.activecolor["lightcolor"])
	maincolor = Color(RuleManager.activecolor["maincolor"])
	darkcolor = Color(RuleManager.activecolor["darkcolor"])
	$BallLight.modulate = lightcolor
	$BallMain.modulate = maincolor
	$BallDark.modulate = darkcolor


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= 1
	#if linear_velocity.y < 10:
	#	sprite.frame = 0
	#elif linear_velocity.y < 20:
	#	sprite.frame = 1
	#elif linear_velocity.y < 40:
	#	sprite.frame = 2
	#else:
	#	sprite.frame = 3

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if !RuleManager.walls:
		if position.x > get_viewport().size.x/(2*3):
			position.x = -get_viewport().size.x/(2*3)
		elif position.x < -get_viewport().size.x/(2*3):
			position.x = get_viewport().size.x/(2*3)

func _on_body_entered(body: Node) -> void:
	if body == $/root/Ingame/Platform:
		linear_velocity.x = (position.x - body.position.x) * body.length/30
	elif body == $/root/Ingame/Wall and timer <= 0:
		timer = 100
		linear_velocity.x *= -1
