extends OptionButton

var testFile = FileAccess.get_file_as_string("res://Data/options.json")
var testArray = JSON.parse_string(testFile)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	testArray[1] = str_to_var(testArray[1])
	print(testArray)
	get_popup().canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	get_popup().id_pressed.connect(pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pressed(id:int)->void:
	var tmp = get_item_text(id).split("x")
	var vec = Vector2i( int(tmp[0]),int(tmp[1]) )
	var scr = DisplayServer.screen_get_size()/2
	DisplayServer.window_set_size(vec)
	DisplayServer.window_set_position(Vector2i(scr.x - vec.x/2 ,scr.y - vec.y/2 ) )
