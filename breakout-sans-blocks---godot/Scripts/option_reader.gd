extends Node

var scr = DisplayServer.screen_get_size()/2
var fileString = FileAccess.get_file_as_string("res://Data/options.json")
var fileArray = JSON.parse_string(fileString)
var vec = str_to_var(fileArray[1])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DisplayServer.window_set_size(vec)
	DisplayServer.window_set_position(Vector2i(scr.x - vec.x/2 ,scr.y - vec.y/2 ) )
	DisplayServer.window_set_mode(int(fileArray[0]) * 3 as DisplayServer.WindowMode)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
