extends Control

var canspin:bool = true
var currentEnemy:int = 0

var x1:float
var y1:float
var x2:float
var y2:float
var angle:float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$Label.text = str(canspin)
	x1 = 60 * cos(angle) - 20
	y1 = 60 * sin(angle) + 40
	x2 = 60 * cos(angle + PI) - 20
	y2 = 60 * sin(angle + PI) + 40
	get_child(0).position = Vector2(x1,y1)
	get_child(1).position = Vector2(x2,y2)
	if get_parent().visible and canspin:
		if Input.is_action_pressed("ui_left"):
			canspin = false
			spin(angle - PI)
		if Input.is_action_pressed("ui_right"):
			canspin = false
			spin(angle + PI)

func spin(tmp:float)->void:
	#print("spun")
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.set_parallel(false)
	tween.tween_property(self,"angle",tmp,0.5)
	tween.tween_callback(stupidbool)
func stupidbool()->void:
	canspin = true
