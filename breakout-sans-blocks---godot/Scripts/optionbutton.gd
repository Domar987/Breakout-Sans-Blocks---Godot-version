extends BaseButton

@export var menuToLoad:Control
@export var Soul:Node2D
@export var Warning:Container
@export var YesButton:BaseButton
@export var NoButton:BaseButton

static var activeWarning:String

var label:Label
var labeltxt:String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var fileString = FileAccess.get_file_as_string("res://Data/options.json")
	var fileArray = JSON.parse_string(fileString)
	match name:
		"Fullscreen":
			button_pressed = fileArray[0]
		"Floor":
			button_pressed = fileArray[9]
			label = get_child(0)
			labeltxt = label.text
		"Hearts":
			button_pressed = fileArray[11]
		"Souls":
			button_pressed = fileArray[12]
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
	if label != null:
		label.text = labeltxt+"\n(x"+str(int(not button_pressed) * 0.05 + 1)+")"

func changeFile(index:int,value:Variant)->void:
	var fileString = FileAccess.get_file_as_string("res://Data/options.json")
	var fileArray = JSON.parse_string(fileString)
	fileArray[index] = value
	var fileUpdate = FileAccess.open("res://Data/options.json",FileAccess.WRITE)
	fileUpdate.store_string(JSON.stringify(fileArray,"\t"))

func _pressed() -> void:
	if name == "RESET":
		warning()
		activeWarning = "BigReset"
	elif name == "BossAgain":
		warning()
		activeWarning = "BossReset"

func _toggled(toggled_on: bool) -> void:
	match name:
		"Fullscreen":
			DisplayServer.window_set_mode(int(toggled_on) * 3 as DisplayServer.WindowMode)
			changeFile(0,toggled_on)
		"Floor":
			changeFile(9,toggled_on)
		"Hearts":
			changeFile(11,toggled_on)
		"Souls":
			create_tween().tween_property(Soul,"modulate",Color(1,1,1,int(toggled_on)),0.25)
			$/root/Menu.disabledEffect = not toggled_on
			changeFile(12,toggled_on)

func warning()->void:
	if Warning.scale <= Vector2.ONE * 0.01:
		create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT).tween_property(Warning,"scale",Vector2.ONE,0.5)

func Yes()->void:
	if Warning.scale == Vector2.ONE:
		#print(activeWarning)
		if (name == "RESET" and activeWarning == "BigReset") or (name == "BossAgain" and activeWarning == "BossReset"):
			var tmp = Callable(self,activeWarning)
			tmp.call()
		create_tween().tween_property(Warning,"scale",Vector2.ZERO,0.2)
func No()->void:
	if Warning.scale == Vector2.ONE:
		create_tween().tween_property(Warning,"scale",Vector2.ZERO,0.2)

func BigReset()->void:
	print("Reset everything")

func BossReset()->void:
	print("See the boss cutscene again")
