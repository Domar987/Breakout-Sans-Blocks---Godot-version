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
	x = 60 * cos(angle) - 20
	y = 60 * sin(angle) + 40
	get_child(0).position = Vector2(x,y)
	if get_parent().visible and canspin:
		if Input.is_action_pressed("ui_left"):
			canspin = false
			spinLeft()
		if Input.is_action_pressed("ui_right"):
			canspin = false
			spinRight()

func spinLeft()->void:
	var tween = create_tween()
	tween.set_parallel()
	var tmp:float = angle + PI
	tween.tween_property(self,"angle",tmp,0.5)
	tween.tween_property(self,"canspin",true,0.6)

func spinRight()->void:
	pass
