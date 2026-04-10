extends Node

@export var wallspreselected = false
var walls:bool
var ballfile = FileAccess.get_file_as_string("res://Data/ball_colors.json")
var ballcolors = JSON.parse_string(ballfile)
var activecolor:Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	activecolor = ballcolors[randi()%6]
	if !wallspreselected:
		walls = randi()%2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$/root/Ingame/Wall.process_mode = 4 * int(!walls)
