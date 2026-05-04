extends Area2D

@export var y = 75.0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
#@export var color1 = Color()
#@export var color2 = Color()
var starttex:Texture2D = load("res://Sprites/platformstart.png")
var segtex:Texture2D = load("res://Sprites/platformsegment.png")
var endtex:Texture2D = load("res://Sprites/platformend.png")

var redraw:bool = false
var length = 100
var oldlength:int
var rect = Rect2()
var rectShape = RectangleShape2D.new()
@onready var collisionShape = $CollisionShape2D

@onready var HurtArea = $HurtArea
@onready var RuleManager = $/root/Ingame/RuleManager

var mousepos:float
var hurtposition:float

const wallwidth = 12

var bottomMargin:int

func _ready() -> void:
	bottomMargin = 90 - y


func _physics_process(delta: float) -> void:
	rectShape.size = Vector2(length, 10)
	collisionShape.set_shape(rectShape)
	rect = Rect2(Vector2(-length/2,-2),Vector2(length,4))
	
	HurtArea.get_child(0).shape.size = Vector2(length, 4)
	
	mousepos = get_global_mouse_position().x
	if mousepos > 960/(2*RuleManager.zoom) - length/2 - int(RuleManager.walls)*wallwidth:
		mousepos = 960/(2*RuleManager.zoom) - length/2 - int(RuleManager.walls)*wallwidth
	elif mousepos < -960/(2*RuleManager.zoom) + length/2 + int(RuleManager.walls)*wallwidth:
		mousepos = -960/(2*RuleManager.zoom) + length/2 + int(RuleManager.walls)*wallwidth
	y = 540/(2*RuleManager.zoom) - bottomMargin
	position = Vector2(mousepos,y) + Vector2(hurtposition,0)
	if redraw:
		queue_redraw()
	if length == 0:
		visible = false
		set_collision_layer_value(1,false)
		set_collision_mask_value(1,false)
	
func _draw():
	#draw_rect(Rect2(Vector2(-length/2,-2),Vector2(length,4)),color)
	#draw_rect(Rect2(Vector2(-length/2+1,-1),Vector2(length-2,2)),color1,true)
	#draw_rect(Rect2(Vector2(-length/2+0.5,-1.5),Vector2(length-1,3)),color2,false,1)
	#draw_line(Vector2(length/2-3,-0.5),Vector2(length/2-1,-0.5),Color.WHITE,1.0)
	#draw_line(Vector2(length/2-1.5,0),Vector2(length/2-1.5,1.0),Color.WHITE,1.0)
	draw_texture(starttex,Vector2(-length/2,-2))
	for i in range(length-6):
		draw_texture(segtex,Vector2(-length/2 + i + 3,-2))
	draw_texture(endtex,Vector2(length/2 - 3,-2))
