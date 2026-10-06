extends BaseButton

@export var menuToLoad:Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if name == "RESET":
		pass
	elif name == "BossAgain":
		pass
	elif name.right(6) == "Button":
		if button_pressed:
			menuToLoad.visible = true
		else:
			menuToLoad.visible = false

func _toggled(toggled_on: bool) -> void:
	if name == "Fullscreen":
		DisplayServer.window_set_mode(int(toggled_on) * 3 as DisplayServer.WindowMode)
		#DisplayServer.window_set_size(vec)
		#DisplayServer.window_set_position(Vector2i(scr.x - vec.x/2 ,scr.y - vec.y/2 ) )
	elif name == "Floor":
		pass
	elif name == "Hearts":
		pass
	elif name == "Souls":
		pass
