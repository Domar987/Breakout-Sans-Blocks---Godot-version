extends OptionButton

var scr = DisplayServer.screen_get_size()/2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_popup().canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	get_popup().id_pressed.connect(pressed)
	var fileString = FileAccess.get_file_as_string("res://Data/options.json")
	var fileArray = JSON.parse_string(fileString)
	var vec = str_to_var(fileArray[1])
	selected = fileArray[2]
	
	DisplayServer.window_set_size(vec)
	DisplayServer.window_set_position(Vector2i(scr.x - vec.x/2 ,scr.y - vec.y/2 ) )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pressed(id:int)->void:
	var fileString = FileAccess.get_file_as_string("res://Data/options.json")
	var fileArray = JSON.parse_string(fileString)
	
	var tmp = get_item_text(id).split("x")
	var vec = Vector2i( int(tmp[0]),int(tmp[1]) )
	DisplayServer.window_set_size(vec)
	DisplayServer.window_set_position(Vector2i(scr.x - vec.x/2 ,scr.y - vec.y/2 ) )
	
	fileArray[1] = var_to_str(vec)
	fileArray[2] = id
	var fileUpdate = FileAccess.open("res://Data/options.json",FileAccess.WRITE)
	fileUpdate.store_string(JSON.stringify(fileArray,"\t"))
