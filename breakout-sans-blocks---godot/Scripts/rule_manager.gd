extends Node

@export var wallspreselected = false
var walls:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !wallspreselected:
		walls = randi()%2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$/root/Ingame/Wall.process_mode = 4 * int(!walls)
