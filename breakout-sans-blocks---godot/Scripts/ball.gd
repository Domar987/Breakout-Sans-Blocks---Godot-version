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
#var ballgravity:float = 9.81
var hitcounter:int = 0

var frozen:bool = false

var canslam:bool = true
var platcontactpos:float
var mouseforce:float

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
	$Label.text = str(canslam)
	if RuleManager.ballPosCheat:
		position = get_global_mouse_position()
		velocity = Vector2.ZERO
	elif not frozen:
		timer -= 1
		if canslam:
			velocity.y += delta * get_gravity()
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and canslam:
			if not $Slam.playing:
				$Slam.play()
			if velocity.y < 50:
				velocity.y = 50
			velocity.y += delta * get_gravity()
		if not canslam:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				#mouseforce += delta * Input.get_last_mouse_velocity().x
				mouseforce += platform.positiondelta.x
				#print(str(Input.get_last_mouse_velocity().x) + "\n" + str(mouseforce))
				if abs(position.x) < 960/(2*RuleManager.zoom):
					position.x = (platform.position.x - platcontactpos) + 5 * delta * mouseforce
				velocity.y = 0
				position.y = platform.position.y - 9.9
				mouseforce -= delta * sign(mouseforce) * 9.81
			else:
				velocity = get_launch(position,platform.position,platform.length,45)
		if position.x > 960/(2*RuleManager.zoom):
			if RuleManager.walls:
				#position = Vector2.ZERO
				#velocity = Vector2.ZERO
				fall(0.25,false)
			else:
				$BallMain/BallTrail.drawline = not $BallMain/BallTrail.drawline
				$BallMain/BallTrail2.drawline = not $BallMain/BallTrail2.drawline
				position.x = -960/(2*RuleManager.zoom)
		elif position.x < -960/(2*RuleManager.zoom):
			if RuleManager.walls:
				#position = Vector2.ZERO
				#velocity = Vector2.ZERO
				fall(0.25,false)
			else:
				$BallMain/BallTrail.drawline = not $BallMain/BallTrail.drawline
				$BallMain/BallTrail2.drawline = not $BallMain/BallTrail2.drawline
				position.x = 960/(2*RuleManager.zoom)
		if position.y > 540/(2*RuleManager.zoom) + 50 and RuleManager.health > 0:
			fall(1.5,true)
		#if linear_velocity.y < 10:
		#	sprite.frame = 0
		#elif linear_velocity.y < 20:
		#	sprite.frame = 1
		#elif linear_velocity.y < 40:
		#	sprite.frame = 2
		#else:
		#	sprite.frame = 3
		position += velocity * delta

func fall(duration:float,damaged:bool)->void:
	if damaged:
		RuleManager.health -= 1
	frozen = true
	$RetrieveBall.play()
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_parallel(false)
	tween.tween_property(self,"position",Vector2.ZERO,duration)
	tween.tween_property(self,"velocity",Vector2.ZERO,0.0)
	tween.tween_property(self,"frozen",false,0.0)

func _on_area_entered(area: Area2D) -> void:
	if area == platform:
		if canslam:
			if $Slam.playing:
				$Slam.stop()
				RuleManager.cameraAddShake(0.75,0.0,0.5)
			mouseforce = 0
			canslam = false
			if position.y > area.position.y:
				pass #ek puan/para
			hitcounter += 1
			if hitcounter % 10 == 0:
				RuleManager.difficulty += 1
			#velocity.y = -(5.0 + RuleManager.difficulty)
			#velocity.y = -sqrt(2*gravity*(platform.y + 540/(2*RuleManager.zoom)))
			#velocity.x = (position.x - area.position.x) * (100.0/area.length) * (10+RuleManager.difficulty/4.0)
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				platcontactpos = platform.position.x - position.x
			else:
				velocity = get_launch(position,platform.position,platform.length,45)
	elif area == wall and timer <= 0:
		timer = 1
		velocity.x *= -1

func get_launch(ballpos:Vector2,platpos:Vector2,length:float,dirLimit:float)->Vector2:
	var lerpvalue = (ballpos.x-platpos.x)/(length/2)
	lerpvalue += 1
	lerpvalue /= 2
	var dir = lerpf(-dirLimit,dirLimit, lerpvalue) + 270
	var magn = sqrt(2*get_gravity()*(platpos.y + 540/(2*RuleManager.zoom)))
	var finalVec:Vector2
	finalVec.x = magn * cos(deg_to_rad(dir))
	finalVec.y = magn * sin(deg_to_rad(dir))
	return finalVec


func _on_area_exited(area: Area2D) -> void:
	if area == platform:# and ((abs(platform.positiondelta.x) < platform.length and not frozen) or position.y > platform.position.y):
		canslam = true
		#create_tween().tween_property(self,"canslam",true,0.1)
