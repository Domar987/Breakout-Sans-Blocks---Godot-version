extends Node

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

@onready var camera:Camera2D = $/root/Ingame/Camera2D
@onready var ball:Area2D = $/root/Ingame/Ball
@onready var platform:Area2D = $/root/Ingame/Platform
@onready var wall:Area2D = $/root/Ingame/Wall
@onready var ui:Control = $/root/Ingame/UI
@onready var heartGenerator:Node = $/root/Ingame/UI/TopLeft/heartGenerator
@onready var zoom:float = camera.zoom.x

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
	Input.warp_mouse(get_viewport().size/2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ui.scale = Vector2.ONE * (3/zoom)
	ui.size = Vector2(960,540)/(zoom * ui.scale)
	ui.position = -Vector2(960,540)/(2*zoom)
	
	if Input.is_action_just_pressed("Cheat1"):
		difficulty += 1
	if Input.is_action_just_pressed("Cheat2"):
		damage = 10
	if Input.is_action_just_pressed("Cheat3"):
		ballPosCheat = not ballPosCheat
	if Input.is_action_just_pressed("Cheat4"):
		health = 100
	if oldDifficulty != difficulty:
		difficultyChange()
	if oldhealth != health:
		healthChange(oldhealth-health)
	$/root/Ingame/Wall.process_mode = (4 * int(!walls)) as ProcessMode
	camera.zoom = Vector2(zoom,zoom)
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
	oldDifficulty = difficulty
	oldhealth = health

func difficultyChange()->void:
	cameraZoom()
	if difficulty % 3 == 0:
		platformLength(platform.length * 0.8)
	if difficulty % 5 == 0:
		cameraRotate()
		ySpeedIncrease()

func healthChange(dmg:int)->void:
	heartGenerator.generateHearts(health)
	var hurttween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).set_parallel(false)
	hurttween.tween_property(platform,"hurtposition",2*dmg,0.075)
	hurttween.set_ease(Tween.EASE_IN_OUT)
	hurttween.tween_property(platform,"hurtposition",-2*dmg,0.15)
	hurttween.tween_property(platform,"hurtposition",dmg,0.075)
	hurttween.tween_property(platform,"hurtposition",-dmg,0.15)
	hurttween.set_ease(Tween.EASE_IN)
	hurttween.tween_property(platform,"hurtposition",0,0.075)
	if health <= 0:
		platformLength(0)

func cameraZoom()->void:
	var tween = create_tween()
	var tmp = zoom * 0.9
	tween.tween_property(self, "zoom", tmp, 1.0)
	#tween.tween_property(camera,"zoom",Vector2(zoom,zoom),1.0)
	#var timer = 0
	#while timer <= 1:
	#	timer += get_physics_process_delta_time()
	#	camera.zoom = lerp(oldzoom,oldzoom*0.9,timer)

func platformLength(newLength:int)->void:
	platform.redraw = true
	var tween = create_tween()
	tween.tween_property(platform, "length", newLength, 1.0)
	tween.tween_callback(platformLengthEnd)

func platformLengthEnd()->void:
	platform.redraw = false

func cameraRotate() -> void:
	var tween = create_tween()
	var tmp = rotate + 1.0
	tween.tween_property(self, "rotate", tmp, 1.0)

func ySpeedIncrease()->void:
	wall.ySpeed += 0.2 + wall.ySpeed
