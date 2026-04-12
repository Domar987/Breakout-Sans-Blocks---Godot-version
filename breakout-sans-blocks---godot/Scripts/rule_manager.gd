extends Node

@export var wallspreselected = false
var walls:bool

var ballfile = FileAccess.get_file_as_string("res://Data/ball_colors.json")
var ballcolors = JSON.parse_string(ballfile)
var activecolor:Dictionary

var difficulty = 0

@onready var camera = $/root/Ingame/Camera2D
@onready var zoom = camera.zoom.x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 1
	activecolor = ballcolors[randi()%6]
	if !wallspreselected:
		walls = randi()%2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$/root/Ingame/Wall.process_mode = 4 * int(!walls)

func difficultyChange()->void:
	cameraZoom()

func cameraZoom()->void:
	var tween = create_tween()
	zoom *= 0.9
	tween.tween_property(camera,"zoom",Vector2(zoom,zoom),1.0)
	#var timer = 0
	#while timer <= 1:
	#	timer += get_physics_process_delta_time()
	#	camera.zoom = lerp(oldzoom,oldzoom*0.9,timer)
