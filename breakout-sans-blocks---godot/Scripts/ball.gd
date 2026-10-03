class_name Ball extends Area2D

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
@onready var floor = $/root/Ingame/Floor

@onready var ballTrail1 = $BallMain/BallTrail
@onready var ballTrail2 = $BallMain/BallTrail2

var velocity:Vector2 = Vector2.ZERO
var hitcounter:int = 0

var frozen:bool = false

var touchingplatf:bool = false
var touchinground:bool = false
var slamming:bool = false
var platcontactpos:float
var mouseforce:float

var wallcounter:int = 0
@onready var CheevoHandler = $/root/Ingame/UI/BottomRight/CheevoHandler
var pointext = load("res://Objects/Score.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	chooseColors(RuleManager.activecolor)
	applyColors()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#$Label.text = "Sl:"+str(slamming)+"Tf:"+str(touchinground)+"Tp:"+str(touchingplatf)
	ballPosCheat()
	
	if not frozen and not RuleManager.ballPosCheat:
		timer -= 1
		if not (touchinground or touchingplatf):
			velocity.y += delta * get_gravity()
		if RuleManager.health > 0:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				if not slamming:
					slamStart()
				else:
					slamStuff(delta)
				slamming = true
			elif slamming == true:
				slamming = false
				slamEnd()
			
			onPlatform(delta)
			
			if abs(position.x) > 960/(2*RuleManager.zoom):
				wallOrPortalInteraction()
			
			fall()
		
		position += velocity * delta


#ready funcs
func chooseColors(chosencolor:Dictionary) -> void:
	lightcolor = Color(chosencolor["lightcolor"])
	maincolor = Color(chosencolor["maincolor"])
	darkcolor = Color(chosencolor["darkcolor"])
	outlinelightcolor = Color(chosencolor["outlinelightcolor"])
	outlinedarkcolor = Color(chosencolor["outlinedarkcolor"])

func applyColors() -> void:
	$BallLight.modulate = lightcolor
	$BallMain.modulate = maincolor
	$BallDark.modulate = darkcolor
	$BallOutlineLight.modulate = outlinelightcolor
	$BallOutlineDark.modulate = outlinedarkcolor
	
	ballTrail1.modulate = maincolor
	ballTrail2.modulate = maincolor

#process funcs
func ballPosCheat()->void:
	if RuleManager.ballPosCheat:
		position = get_global_mouse_position()
		velocity = Vector2.ZERO

func wallOrPortalInteraction()->void:
	if RuleManager.walls:
		spawnPointText(250 * (1 + RuleManager.difficulty/10))
		RuleManager.points += 250 * (1 + RuleManager.difficulty/10)
		moveToCenter(0.25,false)
	else:
		ballTrail1.drawline = not ballTrail1.drawline
		ballTrail2.drawline = not ballTrail2.drawline
		position.x = -sign(position.x) * 960/(2*RuleManager.zoom)

func fall()->void:
	if position.y > 540/(2*RuleManager.zoom) + 50 and RuleManager.health > 0:
		if RuleManager.flying:
			velocity.y = -sqrt(2*get_gravity()*(position.y + 540/(2*RuleManager.zoom)))
		else:
			moveToCenter(1.5,true)
		
		wallcounter = 0

func moveToCenter(duration:float,damaged:bool)->void:
	if damaged:
		RuleManager.health -= 1
	frozen = true
	$RetrieveBall.play()
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_parallel(false)
	tween.tween_property(self,"position",Vector2.ZERO,duration)
	tween.tween_property(self,"velocity",Vector2.ZERO,0.0)
	tween.tween_property(self,"frozen",false,0.0)


func slamStart()->void:
	if not $Slam.playing:
		$Slam.play()
	velocity.x /= 2

func slamEnd()->void:
	if $Slam.playing:
		$Slam.stop()
	velocity.x *= 2
	velocity.y = 50


func slamStuff(delta:float)->void:
	if velocity.y < 50:
		velocity.y = 50
	velocity.y += delta * get_gravity()

func onPlatform(delta:float)->void:
	if touchingplatf:
		if slamming:
			mouseforce += platform.positiondelta.x
			if abs(position.x) < 960/(2*RuleManager.zoom):
				position.x = (platform.position.x - platcontactpos) + 5 * delta * mouseforce
			velocity.y = 0
			position.y = platform.position.y - 9
			mouseforce -= delta * sign(mouseforce) * 9.81
		else:
			velocity = get_launch(position,platform.position,platform.length,45)
	elif touchinground:
		if slamming:
			position.y = floor.position.y - 12
			velocity.x -= 0.5 * velocity.x * delta
			velocity.y = 0
		else:
			velocity = get_launch(velocity,Vector2(0,platform.position.y),559.08203984095864777017213390868,45)


#general
func _on_area_entered(area: Area2D) -> void:
	if area is Platform:
		touchingplatf = true
		statIncrease(area)
		mouseforce = 0
		if slamming:
			RuleManager.cameraAddShake(0.75,0.0,0.5)
			platcontactpos = platform.position.x - position.x
		
		wallcounter = 0
	elif area == floor:
		if slamming:
			RuleManager.cameraAddShake(0.75,0.0,0.5)
		touchinground = true
		
		wallcounter = 0
	elif area == wall and timer <= 0:
		timer = 1
		velocity.x *= -1
		if not (touchinground or touchingplatf):
			wallcounter += 1
			cheevo()

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
	if area == platform:
		touchingplatf = false
	if area == floor:
		touchinground = false

func statIncrease(area:Area2D)->void:
	if position.y > area.position.y and not frozen and floor == null:
		print("Close call!")
		spawnPointText(500 * (1 + RuleManager.difficulty/10))
		RuleManager.points += 500 * (1 + RuleManager.difficulty/10)
	hitcounter += 1
	if hitcounter % 10 == 0:
		RuleManager.difficulty += 1

func cheevo()->void:
	if wallcounter > 1:
		CheevoHandler.unlockCheevo(1)

func spawnPointText(i:int)->void:
	var projectile = pointext.instantiate()
	projectile.position = position
	projectile.point = i
	add_sibling(projectile)
