extends Control

var textfile = FileAccess.get_file_as_string("res://Data/achievements.json")
var enemydescs = JSON.parse_string(textfile)


var canspin:bool = true
var currentEnemy:int = 0

var x:float = 40
var y1:float = 48
var y2:float = 16
var angle:float = 0.0

var onSprite2:bool = false

@onready var sprite1:Sprite2D = get_child(0)
@onready var sprite2:Sprite2D = get_child(1)

@onready var menu:Container = get_parent()

@onready var enemies:int = get_child(0).hframes / 2
@onready var title:Label = get_parent().get_child(1).get_child(0)
@onready var description:Label = get_parent().get_child(1).get_child(1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title.text = enemydescs[0][0]
	description.text = enemydescs[0][1]
	sprite1.frame = 10 * (int(enemydescs[currentEnemy][2]))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$Label.text = str(currentEnemy)
	#title.text = enemydescs[currentEnemy][0]
	#description.text = enemydescs[currentEnemy][1]
	
	sprite1.position = Vector2(x,y1)
	sprite2.position = Vector2(x,y2)
	if menu.visible and canspin:
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
	var tmp1 = y1 + sign * 32
	var tmp2 = y2 + sign * 32
	if tmp1 > 80:
		y1 = 16
		tmp1 = y1 + sign * 32
	elif tmp1 < 16:
		y1 = 80
		tmp1 = y1 + sign * 32
	if tmp2 > 80:
		y2 = 16
		tmp2 = y2 + sign * 32
	elif tmp2 < 16:
		y2 = 80
		tmp2 = y2 + sign * 32
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.set_parallel(true)
	if onSprite2:
		tween.tween_property(sprite1,"scale",Vector2(0.5,0),0.7)
		tween.tween_property(sprite2,"scale",Vector2.ONE,0.7)
	else:
		tween.tween_property(sprite1,"scale",Vector2.ONE,0.7)
		tween.tween_property(sprite2,"scale",Vector2(0.5,0),0.7)
	tween.tween_property(self,"y1",tmp1,0.7)
	tween.tween_property(self,"y2",tmp2,0.7)
	tween.tween_property(title,"text",enemydescs[currentEnemy][0],0.5)
	tween.tween_property(description,"text",enemydescs[currentEnemy][1],0.5)
	tween.tween_callback(stupidbool).set_delay(0.8)
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
		sprite2.frame = currentEnemy % enemies + 10 * (int(enemydescs[currentEnemy][2]))
	else:
		sprite1.frame = currentEnemy % enemies + 10 * (int(enemydescs[currentEnemy][2]))
