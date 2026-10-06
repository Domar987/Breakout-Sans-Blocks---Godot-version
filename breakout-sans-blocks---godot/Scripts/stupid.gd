extends OptionButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_popup().canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	get_popup().id_pressed.connect(pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pressed(id:int)->void:
	var tmp = get_item_text(id).split("x")
	DisplayServer.window_set_size(Vector2i( int(tmp[0]),int(tmp[1]) ) )
	DisplayServer.window_set_position(Vector2i(960 - int(tmp[0])/2 ,540 - int(tmp[1])/2 ) )
