extends BaseButton

@export var menuToLoad:Control
@export var Soul:Node2D
@export var Warning:Container
@export var YesButton:BaseButton
@export var NoButton:BaseButton

var function:Callable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if name == "RESET" or name == "BossAgain":
		Warning.scale = Vector2.ZERO
		YesButton.pressed.connect(Yes)
		NoButton.pressed.connect(No)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if name.right(6) == "Button":
		if button_pressed:
			menuToLoad.visible = true
		else:
			menuToLoad.visible = false

func _pressed() -> void:
	if name == "RESET":
		warning()
		function = Callable(BigReset)
	elif name == "BossAgain":
		warning()
		function = Callable(BossReset)

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
		create_tween().tween_property(Soul,"modulate",Color(1,1,1,int(toggled_on)),0.25)
		$/root/Menu.disabledEffect = not toggled_on

func warning()->void:
	if Warning.scale <= Vector2.ONE * 0.01:
		create_tween().tween_property(Warning,"scale",Vector2.ONE,0.5)

func Yes()->void:
	if Warning.scale == Vector2.ONE:
		function.call()
func No()->void:
	if Warning.scale == Vector2.ONE:
		create_tween().tween_property(Warning,"scale",Vector2.ZERO,0.5)

func BigReset()->void:
	print("Reset everything")

func BossReset()->void:
	print("See the boss cutscene again")
