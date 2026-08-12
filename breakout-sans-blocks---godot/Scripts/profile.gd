extends Control

var canspin:bool = true
var currentEnemy:int = 0

var x1:float
var y1:float
var x2:float
var y2:float
var angle:float = 0.0

var onSprite2:bool = false

@onready var enemies:int = get_child(0).hframes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = str(currentEnemy)
	x1 = 60 * cos(angle) - 30
	y1 = 60 * sin(angle) + 40
	x2 = 60 * cos(angle + PI) - 30
	y2 = 60 * sin(angle + PI) + 40
	get_child(0).position = Vector2(x1,y1)
	get_child(1).position = Vector2(x2,y2)
	if get_parent().visible and canspin:
		if Input.is_action_pressed("ui_left"):
			canspin = false
			spin(-1)
		if Input.is_action_pressed("ui_right"):
			canspin = false
			spin(1)

func spin(sign:float)->void:
	#print("spun")
	enemyCounter(sign)
	swapImage()
	var tmp = angle + sign * PI
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.set_parallel(false)
	tween.tween_property(self,"angle",tmp,0.5)
	tween.tween_callback(stupidbool)
func stupidbool()->void:
	canspin = true

func enemyCounter(amount:float)->void:
	currentEnemy += amount
	if currentEnemy < 0:
		currentEnemy += enemies
	elif currentEnemy >= enemies:
		currentEnemy -= enemies

func swapImage()->void:
	onSprite2 = not onSprite2
	if onSprite2:
		get_child(1).frame = currentEnemy % enemies
	else:
		get_child(0).frame = currentEnemy % enemies
