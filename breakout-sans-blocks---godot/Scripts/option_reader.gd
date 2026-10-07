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
	if get_parent().name == "Ingame":
		var floor = get_node("../Floor")
		var topLeft = get_node("../UI/TopLeft")
		var cama = topLeft.get_child(0)
		floor.visible = fileArray[9]
		floor.process_mode = int(not fileArray[9]) * 4 as Node.ProcessMode
		cama.process_mode = int(fileArray[11]) * 4 as Node.ProcessMode
		cama.visible = not fileArray[11]
		if fileArray[11]:
			topLeft.add_child(load("res://Objects/heart_generator.tscn").instantiate())
	elif get_parent().name == "Menu":
		get_parent().disabledEffect = not fileArray[12]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
