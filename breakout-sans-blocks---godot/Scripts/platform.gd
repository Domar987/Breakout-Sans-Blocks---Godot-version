extends StaticBody2D

@export var y = 100.0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var color1 = Color()
@export var color2 = Color()
var length = 100
var rect = Rect2()
var rectShape = RectangleShape2D.new()
@onready var collisionShape = $CollisionShape2D

@onready var RuleManager = $/root/Ingame/RuleManager

var mousepos:float

const wallwidth = 7


func _physics_process(delta: float) -> void:
	rectShape.size = Vector2(length, 4)
	collisionShape.set_shape(rectShape)
	rect = Rect2(Vector2(-length/2,-2),Vector2(length,4))
	mousepos = get_global_mouse_position().x
	if mousepos > get_viewport().size.x/(2*RuleManager.zoom) - length/2 - int($/root/Ingame/RuleManager.walls)*wallwidth:
		mousepos = get_viewport().size.x/(2*RuleManager.zoom) - length/2 - int($/root/Ingame/RuleManager.walls)*wallwidth
	elif mousepos < -get_viewport().size.x/(2*RuleManager.zoom) + length/2 + int($/root/Ingame/RuleManager.walls)*wallwidth:
		mousepos = -get_viewport().size.x/(2*RuleManager.zoom) + length/2 + int($/root/Ingame/RuleManager.walls)*wallwidth
	position = Vector2(mousepos,y)
	
func _draw():
	#draw_rect(Rect2(Vector2(-length/2,-2),Vector2(length,4)),color)
	draw_rect(Rect2(Vector2(-length/2+1,-1),Vector2(length-2,2)),color1,true)
	draw_rect(Rect2(Vector2(-length/2+0.5,-1.5),Vector2(length-1,3)),color2,false,1)
	draw_line(Vector2(length/2-3,-0.5),Vector2(length/2-1,-0.5),Color.WHITE,1.0)
	draw_line(Vector2(length/2-1.5,0),Vector2(length/2-1.5,1.0),Color.WHITE,1.0)
