extends Control

var canspin:bool = true
var currentEnemy:int = 0

var x:float
var y:float
var angle:float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$Label.text = str(canspin)
	x = 60 * cos(angle) - 20
	y = 60 * sin(angle) + 40
	get_child(0).position = Vector2(x,y)
	if get_parent().visible and canspin:
		if Input.is_action_pressed("ui_left"):
			canspin = false
			spin(angle - PI)
		if Input.is_action_pressed("ui_right"):
			canspin = false
			spin(angle + PI)

func spin(tmp:float)->void:
	#print("spun")
	var tween = create_tween()
	tween.set_parallel(false)
	tween.tween_property(self,"angle",tmp,0.5)
	tween.tween_callback(stupidbool)
func stupidbool()->void:
	canspin = true
