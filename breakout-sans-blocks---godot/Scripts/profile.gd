extends Control

var canspin:bool = true
var currentEnemy:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible and canspin:
		if Input.is_action_pressed("ui_left"):
			canspin = false
			spinLeft()
		if Input.is_action_pressed("ui_right"):
			canspin = false
			spinRight()

func spinLeft()->void:
	pass

func spinRight()->void:
	pass
