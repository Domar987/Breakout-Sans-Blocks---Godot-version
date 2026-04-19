extends Area2D

@onready var RuleManager = $/root/Ingame/RuleManager
@onready var Wall = $/root/Ingame/Wall

var fromLorR:bool = false
var xSpeed:float = 1.0
var entered:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randi_range(0,1):
		fromLorR = true
	var x = (2*int(fromLorR) - 1) * (get_viewport().size.x/(2*RuleManager.zoom) + 11)
	var y = 4 + 16 * randi_range(-get_viewport().size.y/(16*2*RuleManager.zoom),64/16)
	position = Vector2(x, y)
	xSpeed *= -2*int(fromLorR) + 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += xSpeed
	if abs(position.x) < abs(get_viewport().size.x/(2*RuleManager.zoom)) - 2* Wall.wallwidth and !entered:
		entered = true
	if entered and abs(position.x) >= abs(get_viewport().size.x/(2*RuleManager.zoom)) - 2 * Wall.wallwidth:
		xSpeed *= -1
		position.y += 16
	pass
