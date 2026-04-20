extends Node

@export var wallspreselected = false
var walls:bool

var ballfile = FileAccess.get_file_as_string("res://Data/ball_colors.json")
var ballcolors = JSON.parse_string(ballfile)
var activecolor:Dictionary

var difficulty = 0
var oldDifficulty = 0

@onready var camera:Camera2D = $/root/Ingame/Camera2D
@onready var ball:Area2D = $/root/Ingame/Ball
@onready var platform:StaticBody2D = $/root/Ingame/Platform
@onready var wall:StaticBody2D = $/root/Ingame/Wall
@onready var zoom:float = camera.zoom.x

var rotate:float = 0.0
var rotateDir:int = 0
var timer:float = 0.0
var oldRotate:float = 0.0

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
	if Input.is_action_just_pressed("ui_accept"):
		difficulty += 1
	if oldDifficulty != difficulty:
		difficultyChange()
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

func difficultyChange()->void:
	cameraZoom()
	if difficulty % 3 == 0:
		platformLength()
	if difficulty % 5 == 0:
		cameraRotate()
		ySpeedIncrease()

func cameraZoom()->void:
	var tween = create_tween()
	var tmp = zoom * 0.9
	tween.tween_property(self, "zoom", tmp, 1.0)
	#tween.tween_property(camera,"zoom",Vector2(zoom,zoom),1.0)
	#var timer = 0
	#while timer <= 1:
	#	timer += get_physics_process_delta_time()
	#	camera.zoom = lerp(oldzoom,oldzoom*0.9,timer)

func platformLength()->void:
	platform.redraw = true
	var tween = create_tween()
	var tmp = platform.length * 0.8
	tween.tween_property(platform, "length", tmp, 1.0)
	tween.tween_callback(platformLengthEnd)

func platformLengthEnd()->void:
	platform.redraw = false

func cameraRotate() -> void:
	var tween = create_tween()
	var tmp = rotate + 1.0
	tween.tween_property(self, "rotate", tmp, 1.0)

func ySpeedIncrease()->void:
	wall.ySpeed += 0.2 + wall.ySpeed
