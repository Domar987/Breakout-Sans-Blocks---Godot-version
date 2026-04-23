extends Area2D

var colShape1 = WorldBoundaryShape2D.new()
var colShape2 = WorldBoundaryShape2D.new()

var walltexleft:Texture2D = load("res://Sprites/wallleft.png")
var walltexright:Texture2D = load("res://Sprites/wallright.png")
const wallwidth = 12

@onready var RuleManager = $/root/Ingame/RuleManager
var oldzoom:float
var ySpeed:float = 0.0
var ySpeedAddition:float = 0.0

func _ready() -> void:
	colShape1.normal = Vector2(1,0)
	colShape2.normal = Vector2(-1,0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	ySpeedAddition -= ySpeed
	if ySpeedAddition <= -10:
		ySpeedAddition = 0
	colShape1.distance = -960/(2*RuleManager.zoom) + wallwidth
	colShape2.distance = -960/(2*RuleManager.zoom) + wallwidth
	if RuleManager.zoom != oldzoom or ySpeed != 0:
		queue_redraw()
	$CollisionShape2D1.shape = colShape1
	$CollisionShape2D2.shape = colShape2
	oldzoom = RuleManager.zoom

func _draw() -> void:
	if RuleManager.walls:
		for i in range(0,540/(5*RuleManager.zoom)+1): #kamera boyutu carpi duvar sprite'inin yuksekligi
			var x = 960/(2*RuleManager.zoom) + 1
			var y = i*10-540/(2*RuleManager.zoom)
			draw_texture(walltexleft,Vector2(-x, y + ySpeedAddition))
			draw_texture(walltexright,Vector2(x - wallwidth, y + ySpeedAddition))
