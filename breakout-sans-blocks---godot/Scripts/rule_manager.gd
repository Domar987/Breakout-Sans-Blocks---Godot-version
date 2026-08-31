class_name RuleManager extends Node

@export var wallspreselected = false
var walls:bool

var ballfile = FileAccess.get_file_as_string("res://Data/ball_colors.json")
var ballcolors = JSON.parse_string(ballfile)
var activecolor:Dictionary

var difficulty = 0
var oldDifficulty = 0

var maxHealth:int = 10
var health:int = 10
var damage:int = 1
var oldhealth:int = 10
var kill:int = 0

var invitimer:float = 2.0

var ySpeed:float=0.0

@onready var camera:Camera2D = $/root/Ingame/Camera2D
@onready var ball:Area2D = $/root/Ingame/Ball
@onready var platform:Area2D = $/root/Ingame/Platform
@onready var wall:Area2D = $/root/Ingame/Wall
@onready var portal:Area2D = $/root/Ingame/PortalVisual
@onready var background:Sprite2D = $/root/Ingame/Background
@onready var ui:Control = $/root/Ingame/UI
@onready var heartGenerator:Node = $/root/Ingame/UI/TopLeft/heartGenerator

@onready var zoom:float = camera.zoom.x
var zoommult:float = 0.9

var rotate:float = 0.0
var rotateDir:int = 0
var timer:float = 0.0
var oldRotate:float = 0.0

var ballPosCheat:bool = false

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	Engine.time_scale = 1
	activecolor = ballcolors[randi()%6]
	if !wallspreselected:
		walls = randi()%2
func _ready() -> void:
	get_parent().modulate = Color.BLACK
	create_tween().set_trans(Tween.TRANS_QUAD).set_parallel(false).tween_property(get_parent(),"modulate",Color.WHITE,0.5)
	Input.warp_mouse(get_viewport().size/2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	uiTransform()
	
	cheats()
	
	if oldDifficulty != difficulty:
		difficultyChange()
	if oldhealth != health:
		healthChange(oldhealth-health)
	
	$/root/Ingame/Wall.process_mode = (4 * int(!walls)) as ProcessMode
	camera.zoom = Vector2(zoom,zoom)
	
	cameraRotationLerp(delta)
	
	oldDifficulty = difficulty
	oldhealth = health

func _physics_process(delta: float) -> void:
	if invitimer > 0:
		invitimer -= delta

func uiTransform()->void:
	ui.scale = Vector2.ONE * (3/zoom)
	ui.size = Vector2(960,540)/(zoom * ui.scale)
	ui.position = -Vector2(960,540)/(2*zoom)

func cheats()->void:
	if Input.is_action_just_pressed("Cheat1"):
		difficulty += 1
	if Input.is_action_just_pressed("Cheat2"):
		damage = 10
	if Input.is_action_just_pressed("Cheat3"):
		ballPosCheat = not ballPosCheat
	if Input.is_action_just_pressed("Cheat4"):
		maxHealth = 100
		health = 100
	if Input.is_action_just_pressed("Cheat5"):
		shatterScreen()

func difficultyChange()->void:
	cameraZoom()
	if difficulty % 3 == 0:
		cameraRotate()
		ySpeedIncrease()
	if difficulty % 5 == 0:
		platformLength(platform.length * 0.8)

func healthChange(dmg:int)->void:
	if invitimer > 0:
		health += dmg
	else:
		invitimer = 2.0
		heartGenerator.generateHearts(health)
		
		hurtmodulatetween(dmg)
		hurtpositiontween(dmg)
		
		if health <= 0:
			death()

func hurtmodulatetween(dmg:int)->void:
	var tmptimer = 0.0
	var hurttween = create_tween().set_trans(Tween.TRANS_LINEAR).set_parallel(false)
	tmptimer += 0.3
	while tmptimer < 2.0:
		hurttween.tween_property(platform,"modulate",Color(1+dmg,1+dmg,1+dmg,1),0.1)
		hurttween.tween_property(platform,"modulate",Color.WHITE,0.2)
		tmptimer += 0.3

func hurtpositiontween(dmg:int)->void:
	var hurttween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).set_parallel(false)
	hurttween.tween_property(platform,"hurtposition",2*dmg,0.075)
	hurttween.set_ease(Tween.EASE_IN_OUT)
	hurttween.tween_property(platform,"hurtposition",-2*dmg,0.15)
	hurttween.tween_property(platform,"hurtposition",dmg,0.075)
	hurttween.tween_property(platform,"hurtposition",-dmg,0.15)
	hurttween.set_ease(Tween.EASE_IN)
	hurttween.tween_property(platform,"hurtposition",0,0.075)

func death()->void:
	create_tween().tween_property(self,"ySpeed",0,3.0)
	var tween = create_tween().set_parallel(false)
	tween.tween_property($/root/Ingame/Arkanoid,"pitch_scale",0.01,2.5)
	tween.tween_property($/root/Ingame/Arkanoid,"playing",false,0.0)
	platformLength(0)

func cameraZoom()->void:
	var tween = create_tween()
	var tmp = zoom * zoommult
	tween.tween_property(self, "zoom", tmp, 1.0)
	#tween.tween_property(camera,"zoom",Vector2(zoom,zoom),1.0)
	#var timer = 0
	#while timer <= 1:
	#	timer += get_physics_process_delta_time()
	#	camera.zoom = lerp(oldzoom,oldzoom*0.9,timer)
	if (zoommult * 1.01 < 1):
		zoommult *= 1.01
	else:
		zoommult = (zoommult + 1)/2

func cameraAddShake(amount:float, falloffdelay:float, fallofftime:float) -> void:
	camera.shakeAmount += amount
	await get_tree().create_timer(falloffdelay).timeout
	var decreaseAmount = amount / (fallofftime * 10)
	while fallofftime > 0:
		await get_tree().create_timer(0.1).timeout
		camera.shakeAmount -= decreaseAmount
		fallofftime -= 0.1

func cameraRotate() -> void:
	#var tween = create_tween()
	#var tmp = rotate + 1.0
	#tween.tween_property(self, "rotate", tmp, 1.0)
	pass

func cameraRotationLerp(delta)->void:
	if rotate > 0:
		if rotateDir == 0:
			rotateDir = 1
			timer = 0
		camera.rotation = lerp(oldRotate, deg_to_rad(rotate * rotateDir), timer)
		if timer >= 1:
			timer = 0
			rotateDir *= -1
			oldRotate = camera.rotation
		timer += delta

func platformLength(newLength:int)->void:
	platform.redraw = true
	var tween = create_tween()
	tween.tween_property(platform, "length", newLength, 1.0)
	tween.tween_callback(platformLengthEnd)

func platformLengthEnd()->void:
	platform.redraw = false


func ySpeedIncrease()->void:
	ySpeed += 12

func shatterScreen()->void:
	#var firsttick = Time.get_ticks_msec()
	#print(Time.get_ticks_msec() - firsttick)
	var screenshot = get_viewport().get_texture().get_image()
	var cracktemplates = []
	var crackmovementscript = load("res://Scripts/crackmovement.gd")
	
	var crackpath:String = "/root/Ingame/Camera2D/Cracks/Crack"
	for i in range(1,27):
		cracktemplates.append(get_node(crackpath+str(i)))
	
	for crack:Sprite2D in cracktemplates:
		var cracktex:Image = crack.texture.get_image()
		var corner:Vector2 = zoom*(crack.global_position - (Vector2(cracktex.get_width(),cracktex.get_height())/2))
		
		for y in cracktex.get_height():
			for x in cracktex.get_width():
				var pixelpos:Vector2 = corner + Vector2(x,y) * zoom + Vector2.ONE*zoom/2
				if abs(pixelpos.x) < 960/(2) and abs(pixelpos.y) < 540/(2) and cracktex.get_pixel(x,y) == Color.BLACK:
					var screenshotpixel:Vector2 = (Vector2(screenshot.get_size())/Vector2(960,540)) * (pixelpos + (Vector2(960,540)/2))
					cracktex.set_pixel(x,y,screenshot.get_pixelv(screenshotpixel))
		
		for y in cracktex.get_height():
			for x in cracktex.get_width():
				if cracktex.get_pixel(x,y) == Color.BLACK:
					cracktex.set_pixel(x,y,Color.TRANSPARENT)
		
		var crackclone = crack.duplicate()
		#crackclone.name = crack.name + "Clone"
		crackclone.texture = ImageTexture.create_from_image(cracktex)
		crackclone.z_index = 10
		crackclone.set_script(crackmovementscript)
		crackclone.zoom = zoom
		crackclone.modulate = Color(1.25,1.25,1.25, 1.0)
		add_sibling(crackclone)
	#print(Time.get_ticks_msec() - firsttick)

func levelChange()->void:
	if walls:
		wall.updateColor()
